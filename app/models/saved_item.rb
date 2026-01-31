class SavedItem < ApplicationRecord
  belongs_to :user

  validates :url, presence: true
  validates :user, presence: true
  validates :url, uniqueness: { scope: :user_id }

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

end