class SavedItem < ApplicationRecord

  belongs_to :user

  ALLOWED_STATES = %w[unread viewed read archived].freeze

  enum :state,
       {
         unread: "unread",
         viewed: "viewed",
         read: "read",
         archived: "archived"
       },
       default: "unread"


  before_validation :derive_domain_from_url, if: -> { domain.blank? && url.present? }

  validates :url, presence: true
  validates :user, presence: true
  validates :url, uniqueness: { scope: :user_id }
   validates :state, presence: true, inclusion: { in: ALLOWED_STATES }
  
  scope :for_user, ->(user) { where(user: user) }



  # Create-or-reuse a SavedItem for a given user + url.
  #
  # Returns:
  #   [saved_item, already_saved_boolean]
  #
  # Notes:
  # - Best-effort dedupe: exact match on stored url string.
  # - Race-safe: relies on the unique DB index (user_id, url).
  def self.create_or_reuse_for(user:, url:)
    saved_item = user.saved_items.create_or_find_by!(url: url)
    already_saved = !saved_item.previously_new_record?

    [saved_item, already_saved]
  rescue ActiveRecord::RecordNotUnique
    # In case of concurrent insert, fall back to finding the existing record.
    [user.saved_items.find_by!(url: url), true]
  end

  # Best-effort domain derivation from url.
  # - Local parsing only (no network).
  # - Never raises; never blocks saving.
  def derive_domain_from_url
    self.domain = self.class.extract_domain(url)
  rescue StandardError
    # Non-blocking by design.
    nil
  end

  # Backfill helper for reused records (no validations; non-blocking).
  def ensure_domain!
    return if domain.present? || url.blank?

    derived = self.class.extract_domain(url)
    return if derived.blank?

    # Avoid triggering other validations/callbacks; keep this best-effort and local.
    update_column(:domain, derived)
  rescue StandardError
    nil
  end

  def self.extract_domain(raw_url)
    return nil if raw_url.blank?

    s = raw_url.to_s.strip
    return nil if s.blank?

    uri = URI.parse(s)
    host = uri.host

    # Handle URLs without scheme (e.g., "example.com/path") as best-effort.
    if host.blank? && uri.scheme.nil?
      uri = URI.parse("https://#{s}")
      host = uri.host
    end

    host&.downcase
  rescue URI::InvalidURIError
    nil
  end


end