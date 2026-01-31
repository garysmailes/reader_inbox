class AddMetadataAndStateToSavedItems < ActiveRecord::Migration[8.1]
  def change
    add_column :saved_items, :fetched_title, :string
    add_column :saved_items, :domain, :string
    add_column :saved_items, :state, :string, null: false, default: "unread"
    add_column :saved_items, :last_viewed_at, :datetime
  end
end
