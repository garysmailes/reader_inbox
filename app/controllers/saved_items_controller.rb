class SavedItemsController < ApplicationController
  # Global auth is already enforced at ApplicationController
  before_action :set_saved_item, only: [:update, :destroy]

  def index
    @saved_items = Current.user.saved_items.order(created_at: :desc)
  end

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
      redirect_to inbox_path,
                  alert: @saved_item.errors.full_messages.to_sentence.presence || "Could not save URL."
    end
  rescue ActiveRecord::RecordNotUnique
    # Race-safe dedupe: DB unique index (user_id, url) is the source of truth.
    existing = Current.user.saved_items.find_by!(url: url)

    flash[:saved_item_status] = "already_saved"
    flash[:saved_item_id] = existing.id
    redirect_to inbox_path, notice: "Already saved."
  end

  def update
    if @saved_item.update(saved_item_params)
      redirect_to inbox_path, notice: "Updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @saved_item.destroy
    redirect_to inbox_path, notice: "Removed."
  end

  private

  def set_saved_item
    @saved_item = Current.user.saved_items.find(params[:id])
  end

  def saved_item_params
    # user_id is deliberately NOT permitted
    params.require(:saved_item).permit(:url)
  end
end
