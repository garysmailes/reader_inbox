module SavedItemsHelper
  def clean_url_for(saved_item)
    saved_item.url
      .to_s
      .strip
      .sub(/\Ahttps?:\/\//, "")
      .sub(/\Awww\./, "")
  end

    def metadata_unavailable?(saved_item)
      # Show this note only when we had to fall back to displaying the clean URL,
      # i.e., when the title is unavailable.
      saved_item.fetched_title.blank?
    end
end
