class SavedItemsController < ApplicationController
  # Global auth is already enforced at ApplicationController

  def index
    @saved_items = Current.user
      .saved_items
      .order(created_at: :desc)
  end

  def create
    url = params.dig(:saved_item, :url).to_s.strip

    if url.blank?
      redirect_to inbox_path, alert: "URL is required."
      return
    end

    saved_item, already_saved = SavedItem.create_or_reuse_for(user: Current.user, url: url)

    # Provide a structured indicator the UI can use (beyond copy).
    flash[:saved_item_status] = already_saved ? "already_saved" : "created"
    flash[:saved_item_id] = saved_item.id

    if already_saved
      redirect_to inbox_path, notice: "Already saved."
      return
    end

    # Metadata enrichment remains non-blocking and is only triggered for new records.
    FetchSavedItemMetadataJob.perform_later(saved_item.id)

    redirect_to inbox_path, notice: "Saved."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to inbox_path, alert: e.record.errors.full_messages.to_sentence.presence || "Could not save URL."
  end




  def update
    @saved_item = Current.user.saved_items.find(params[:id])

    if @saved_item.update(saved_item_params)
      redirect_to inbox_path, notice: "Updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    saved_item = Current.user.saved_items.find(params[:id])
    saved_item.destroy

    redirect_to inbox_path, notice: "Removed."
  end

  private

  def saved_item_params
    # user_id is deliberately NOT permitted
    params.require(:saved_item).permit(:url)
  end
end
