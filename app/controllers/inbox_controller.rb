class InboxController < ApplicationController
  def show
    @saved_items = Current.user.saved_items.active_inbox.order(created_at: :desc)
  end
end
