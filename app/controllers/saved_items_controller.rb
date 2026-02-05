class SavedItemsController < ApplicationController
  # Global auth is already enforced at ApplicationController
  before_action :set_saved_item, only: [:open, :destroy, :update_state, :archive, :unarchive]

  def create
    url = saved_item_params[:url].to_s.strip

    if url.blank?
      redirect_to inbox_path, alert: "URL is required.", status: :see_other
      return
    end

    # Best-effort dedupe (exact string match; no aggressive normalisation)
    existing = Current.user.saved_items.find_by(url: url)
    if existing
      existing.ensure_domain!

      flash[:saved_item_status] = "already_saved"
      flash[:saved_item_id] = existing.id
      redirect_to inbox_path, notice: "Already saved.", status: :see_other
      return
    end

    @saved_item = Current.user.saved_items.new(url: url)

    if @saved_item.save
      flash[:saved_item_status] = "created"
      flash[:saved_item_id] = @saved_item.id

      begin
        FetchSavedItemMetadataJob.set(wait: 1.second).perform_later(@saved_item.id)
      rescue StandardError
        # Metadata fetching is opportunistic and must never block saving.
        nil
      end

      redirect_to inbox_path, notice: "Saved.", status: :see_other
    else
      redirect_to inbox_path, alert: @saved_item.errors.full_messages.to_sentence.presence || "Could not save URL."
    end
  rescue ActiveRecord::RecordNotUnique
    # Race-safe dedupe: DB unique index (user_id, url) is the source of truth.
    existing = Current.user.saved_items.find_by!(url: url)

    flash[:saved_item_status] = "already_saved"
    flash[:saved_item_id] = existing.id
    redirect_to inbox_path, notice: "Already saved.", status: :see_other
  end

  # "First open" automation:
  # - If Unread, transition to Viewed and record last_viewed_at.
  # - Never auto-mark Read.
  # - No behavior/engagement inference.
  def open
    @saved_item.mark_first_open_as_viewed!

    redirect_to @saved_item.url, allow_other_host: true
  rescue ActionController::Redirecting::UnsafeRedirectError, URI::InvalidURIError
    redirect_to inbox_path, alert: "Could not open that URL.", status: :see_other
  end

  def destroy
    @saved_item.destroy
    redirect_to inbox_path, notice: "Removed.", status: :see_other
  end

  # Manual, reversible state updates.
  # - User-initiated only (never called by automation).
  # - Scoped to Current.user via set_saved_item.
  # - Does not infer reading; "read" is allowed only via explicit user action.
  def update_state
    requested_state = saved_item_state_params[:state].to_s

    if requested_state.blank?
      redirect_back fallback_location: inbox_path, alert: "State is required."
      return
    end

    unless SavedItem::ALLOWED_STATES.include?(requested_state)
      redirect_back fallback_location: inbox_path, alert: "Invalid state."
      return
    end

    if @saved_item.update(state: requested_state)
      redirect_back fallback_location: inbox_path, notice: "Updated."
    else
      redirect_back fallback_location: inbox_path, alert: @saved_item.errors.full_messages.to_sentence
    end
  end

  # Explicit user intent: move item into Archived state.
  # - Auth is enforced globally in ApplicationController.
  # - Ownership is enforced by set_saved_item scoping to Current.user.
  # - No deletion; this is a state change only.
  def archive
    if @saved_item.update(state: "archived")
      redirect_back fallback_location: inbox_path, notice: "Archived."
    else
      redirect_back fallback_location: inbox_path, alert: @saved_item.errors.full_messages.to_sentence
    end
  end

  # Explicit user intent: move item OUT of Archived into an explicit non-archived state.
  #
  # Contract:
  # - Caller must provide an explicit target state via params[:saved_item][:state]
  # - Allowed targets: unread, viewed, read
  # - We do NOT infer a "restore previous state" rule here.
  def unarchive
    target_state = saved_item_state_params[:state].to_s

    allowed_targets = %w[unread viewed read]
    unless allowed_targets.include?(target_state)
      redirect_back fallback_location: inbox_path, alert: "Invalid unarchive state."
      return
    end

    # Keep behavior strict and predictable: only unarchive items that are currently archived.
    unless @saved_item.state == "archived"
      redirect_back fallback_location: inbox_path, alert: "Item is not archived."
      return
    end

    if @saved_item.update(state: target_state)
      redirect_back fallback_location: inbox_path, notice: "Unarchived."
    else
      redirect_back fallback_location: inbox_path, alert: @saved_item.errors.full_messages.to_sentence
    end
  end

  private

  def set_saved_item
    # Defensive: global auth should ensure Current.user exists, but never allow a nil-scope fallback.
    raise ActiveRecord::RecordNotFound if Current.user.nil?

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
