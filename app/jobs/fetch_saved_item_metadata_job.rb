class FetchSavedItemMetadataJob < ApplicationJob
  queue_as :default

  def perform(saved_item_id)
    saved_item = SavedItem.find_by(id: saved_item_id)
    return unless saved_item

    # Best-effort enrichment: don't refetch if we already have a title.
    return if saved_item.fetched_title.present?

    SavedItemMetadataFetcher.call(saved_item)
  end
end
