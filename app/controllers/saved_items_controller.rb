class SavedItemsController < ApplicationController
  # Global auth is already enforced at ApplicationController
  before_action :set_saved_item, only: [:open, :destroy, :update_state, :mark_read]


  def create
    url = params.dig(:saved_item, :url).to_s.strip

    if url.blank?
      redirect_to inbox_path, alert: "URL is required."
      return
    end

    # Best-effort dedupe (exact string match; no aggressive normalisation)
    existing = Current.user.saved_items.find_by(url: url)
    if existing
      existing.ensure_domain!

      flash[:saved_item_status] = "already_saved"
      flash[:saved_item_id] = existing.id
      redirect_to inbox_path, notice: "Already saved."
      return
    end

    @saved_item = Current.user.saved_items.new(url: url)

    if @saved_item.save
      flash[:saved_item_status] = "created"
      flash[:saved_item_id] = @saved_item.id

      begin
        FetchSavedItemMetadataJob.perform_later(@saved_item.id)
      rescue StandardError
        # Metadata fetching is opportunistic and must never block saving.
        nil
      end

      redirect_to inbox_path, notice: "Saved."
    else
      redirect_to inbox_path, alert: @saved_item.errors.full_messages.to_sentence.presence || "Could not save URL."
    end
  rescue ActiveRecord::RecordNotUnique
    # Race-safe dedupe: DB unique index (user_id, url) is the source of truth.
    existing = Current.user.saved_items.find_by!(url: url)

    flash[:saved_item_status] = "already_saved"
    flash[:saved_item_id] = existing.id
    redirect_to inbox_path, notice: "Already saved."
  end

  # "First open" automation:
  # - If Unread, transition to Viewed and record last_viewed_at.
  # - Never auto-mark Read.
  # - No behavior/engagement inference.
  def open
    @saved_item.mark_first_open_as_viewed!

    redirect_to @saved_item.url, allow_other_host: true
  rescue ActionController::Redirecting::UnsafeRedirectError, URI::InvalidURIError
    redirect_to inbox_path, alert: "Could not open that URL."
  end

  def destroy
    @saved_item.destroy
    redirect_to inbox_path, notice: "Removed."
  end

  def update_state
    requested_state = saved_item_state_params[:state].to_s

    if requested_state.blank?
      redirect_back fallback_location: inbox_path, alert: "State is required."
      return
    end

    if @saved_item.update(state: requested_state)
      redirect_back fallback_location: inbox_path, notice: "Updated."
    else
      redirect_back fallback_location: inbox_path, alert: @saved_item.errors.full_messages.to_sentence
    end
  end

  def mark_read
    if @saved_item.update(state: "read")
      redirect_back fallback_location: inbox_path, notice: "Marked as read."
    else
      redirect_back fallback_location: inbox_path, alert: @saved_item.errors.full_messages.to_sentence
    end
  end


  private

  def set_saved_item
    @saved_item = Current.user.saved_items.find(params[:id])
  end

  def saved_item_params
    # user_id is deliberately NOT permitted
    params.require(:saved_item).permit(:url)
  end

  def saved_item_state_params
    params.require(:saved_item).permit(:state)
  end
end
