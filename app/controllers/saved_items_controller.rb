class SavedItemsController < ApplicationController
  # Global auth is already enforced at ApplicationController

  def index
    @saved_items = Current.user
      .saved_items
      .order(created_at: :desc)
  end

  def show
    @saved_item = Current.user.saved_items.find(params[:id])
  end

  def create
    @saved_item = Current.user.saved_items.new(saved_item_params)

  if @saved_item.save
    FetchSavedItemMetadataJob.perform_later(@saved_item.id)
    redirect_to inbox_path, notice: "Saved."
    else
      render :new, status: :unprocessable_entity
    end
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
    @saved_item = Current.user.saved_items.find(params[:id])
    @saved_item.destroy

    redirect_to inbox_path, notice: "Removed."
  end

  private

  def saved_item_params
    # user_id is deliberately NOT permitted
    params.require(:saved_item).permit(:url)
  end
end
