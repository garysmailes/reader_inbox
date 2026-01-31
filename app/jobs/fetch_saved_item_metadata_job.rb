class FetchSavedItemMetadataJob < ApplicationJob
  queue_as :default

  def perform(saved_item_id)
    saved_item = SavedItem.find_by(id: saved_item_id)
    return unless saved_item

    SavedItemMetadataFetcher.call(saved_item)
  end
end
