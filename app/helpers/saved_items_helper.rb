module SavedItemsHelper
  def clean_url_for(saved_item)
    saved_item.url
      .to_s
      .strip
      .sub(/\Ahttps?:\/\//, "")
      .sub(/\Awww\./, "")
  end

  def metadata_unavailable?(saved_item)
    saved_item.fetched_title.blank? || saved_item.domain.blank?
  end
end
