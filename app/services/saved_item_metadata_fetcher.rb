# app/services/saved_item_metadata_fetcher.rb
require "net/http"
require "uri"

class SavedItemMetadataFetcher
  # Best-effort, non-blocking by design when invoked via a background job.
  # Never raises to callers (it returns false on failure).
  DEFAULT_TIMEOUT_SECONDS = 2
  MAX_BODY_BYTES = 512 * 1024 # 512KB is enough to find <title>

  def self.call(saved_item)
    new(saved_item).call
  end

  def initialize(saved_item)
    @saved_item = saved_item
  end

  def call
    uri = parse_uri(@saved_item.url)
    unless uri
      mark_failed_if_no_metadata!
      return false
    end

    # Domain can be derived without any network call.
    domain = uri.host&.downcase
    update_domain(domain) if domain.present?

    html = fetch_html(uri)
    if html.blank?
      # Domain may still have been set; resolve status accordingly.
      resolve_metadata_status!
      return true
    end

    title = extract_title(html)
    update_title(title) if title.present?

    resolve_metadata_status!
    true
  rescue StandardError
    # Best-effort means: never break upstream flows.
    mark_failed_if_no_metadata!
    false
  end

  private

  def parse_uri(url)
    raw = url.to_s.strip
    return nil if raw.blank?

    uri = URI.parse(raw)

    # If a user pastes "example.com/article", treat as https.
    if uri.scheme.nil? && uri.host.nil?
      uri = URI.parse("https://#{raw}")
    end

    return nil unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    return nil if uri.host.blank?

    uri
  rescue URI::InvalidURIError
    nil
  end

  def fetch_html(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.open_timeout = DEFAULT_TIMEOUT_SECONDS
    http.read_timeout = DEFAULT_TIMEOUT_SECONDS

    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "ReaderInboxMetadataFetcher/1.0"
    request["Accept"] = "text/html,application/xhtml+xml"

    response = http.request(request)
    return nil unless response.is_a?(Net::HTTPSuccess)

    body = response.body.to_s
    body.bytesize > MAX_BODY_BYTES ? body.byteslice(0, MAX_BODY_BYTES) : body
  rescue StandardError
    nil
  end

  def extract_title(html)
    # Best-effort extraction without extra gems.
    # Handles newlines and ignores case.
    match = html.match(/<title[^>]*>(.*?)<\/title>/im)
    return nil unless match

    title = match[1].to_s
    title = title.gsub(/\s+/, " ").strip
    title.presence
  end

  def update_domain(domain)
    # Don't overwrite if already set; this is opportunistic.
    return if @saved_item.domain.present?

    # Use update_columns: this is background best-effort enrichment.
    @saved_item.update_columns(domain: domain, updated_at: Time.current)
  end

  def update_title(title)
    return if @saved_item.fetched_title.present?

    @saved_item.update_columns(fetched_title: title, updated_at: Time.current)
  end

  # Resolve metadata_status after we have attempted enrichment.
  # Rules:
  # - succeeded if title OR domain is present (either was pre-existing or we set it)
  # - failed only if BOTH are absent
  def resolve_metadata_status!
    return if @saved_item.metadata_status == "succeeded"

    if @saved_item.fetched_title.present? || @saved_item.domain.present?
      @saved_item.update_columns(metadata_status: "succeeded", updated_at: Time.current)
    else
      @saved_item.update_columns(metadata_status: "failed", updated_at: Time.current)
    end
  rescue StandardError
    nil
  end

  # Only mark failed if nothing useful exists; never downgrade succeeded.
  def mark_failed_if_no_metadata!
    return if @saved_item.metadata_status == "succeeded"
    return if @saved_item.fetched_title.present? || @saved_item.domain.present?

    @saved_item.update_columns(metadata_status: "failed", updated_at: Time.current)
  rescue StandardError
    nil
  end
end
