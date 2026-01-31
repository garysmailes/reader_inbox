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
    return false unless uri

    # Domain can be derived without any network call.
    domain = uri.host&.downcase
    update_domain(domain) if domain.present?

    html = fetch_html(uri)
    return true if html.blank? # Domain may still have been set.

    title = extract_title(html)
    update_title(title) if title.present?

    true
  rescue StandardError
    # Best-effort means: never break upstream flows.
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

    @saved_item.update(domain: domain)
  end

  def update_title(title)
    return if @saved_item.fetched_title.present?

    @saved_item.update(fetched_title: title)
  end
end
