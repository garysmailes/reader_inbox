class AddForeignKeyToSavedItemsUser < ActiveRecord::Migration[8.1]
   def change
    add_foreign_key :saved_items, :users
  end
end
