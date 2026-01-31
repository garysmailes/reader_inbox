class ArchiveController < ApplicationController
  def show
    @saved_items = Current.user.saved_items.where(state: "archived").order(created_at: :desc)
  end
end
