class SavedItem < ApplicationRecord
  belongs_to :user

  validates :url, presence: true
  validates :state, presence: true

  scope :for_user, ->(user) { where(user: user) }
end
