module SavedItemsHelper
  def clean_url_for(saved_item)
    saved_item.url
      .to_s
      .strip
      .sub(/\Ahttps?:\/\//, "")
      .sub(/\Awww\./, "")
  end

  def metadata_unavailable?(saved_item)
    saved_item.fetched_title.blank?
  end

  def saved_item_state_label(saved_item)
    case saved_item.state.to_s
    when "unread" then "Unread"
    when "viewed" then "Viewed"
    when "read" then "Read"
    when "archived" then "Archived"
    else "Unknown"
    end
  end
end
