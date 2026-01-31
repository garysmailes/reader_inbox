class AddForeignKeyToSavedItemsUser < ActiveRecord::Migration[8.1]
  def change
    return if foreign_key_exists?(:saved_items, :users)

    add_foreign_key :saved_items, :users
  end
end
