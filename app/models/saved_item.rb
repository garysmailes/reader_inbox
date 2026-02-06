class SavedItem < ApplicationRecord
  belongs_to :user

  METADATA_STATUSES = %w[pending succeeded failed].freeze
  ALLOWED_STATES = %w[unread viewed read archived].freeze

  enum :state,
       {
         unread: "unread",
         viewed: "viewed",
         read: "read",
         archived: "archived"
       },
       default: "unread"

  before_validation :set_default_state, on: :create
  before_validation :derive_domain_from_url, if: -> { domain.blank? && url.present? }
  before_validation :derive_clean_url_from_url, if: -> { clean_url.blank? && url.present? }

  validates :state, presence: true, inclusion: { in: ALLOWED_STATES }
  validates :url, presence: true
  validates :user, presence: true
  validates :url, uniqueness: { scope: :user_id }
  validates :metadata_status, inclusion: { in: METADATA_STATUSES }

  after_update_commit :broadcast_refresh_inbox_item
  after_destroy_commit :broadcast_remove_inbox_item


  # Scopes
  scope :for_user, ->(user) { where(user: user) }
  scope :active_inbox, -> { where.not(state: "archived") }
  scope :archived, -> { where(state: "archived") }


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

  # Ensure a canonical default state on create.
  # Do NOT infer any lifecycle progression here.
  def set_default_state
    self.state = "unread" if state.blank?
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

  # Best-effort clean URL derivation from url.
  # - Local string manipulation only (no network).
  # - Never raises; never blocks saving.
  # - Purpose: persisted fallback display value when metadata is unavailable.
  def derive_clean_url_from_url
    self.clean_url = self.class.extract_clean_url(url)
  rescue StandardError
    nil
  end

  def self.extract_clean_url(raw_url)
    return nil if raw_url.blank?

    raw = raw_url.to_s.strip
    return nil if raw.blank?

    clean = raw
              .sub(/\Ahttps?:\/\//, "")
              .sub(/\Awww\./, "")

    clean = raw if clean.blank?
    clean
  end

def metadata_pending?
  metadata_status == "pending"
end

def metadata_succeeded?
  metadata_status == "succeeded"
end

def metadata_failed?
  metadata_status == "failed"
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

  # "First open" automation:
  # - If Unread, transition to Viewed and record last_viewed_at.
  # - Never auto-mark Read.
  # - Best-effort: must not block opening the link.
  def mark_first_open_as_viewed!
    return unless unread?

    update_columns(
      state: "viewed",
      last_viewed_at: Time.current,
      updated_at: Time.current
    )
  rescue StandardError
    nil
  end

def broadcast_refresh_inbox_item
  broadcast_replace_later_to(
    [user, :saved_items],
    target: ActionView::RecordIdentifier.dom_id(self),
    partial: "saved_items/saved_item",
    locals: { item: self }
  )
end

def broadcast_remove_inbox_item
  broadcast_remove_to(
    [user, :saved_items],
    target: ActionView::RecordIdentifier.dom_id(self)
  )
end




end
