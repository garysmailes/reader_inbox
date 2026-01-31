class CreateSavedItems < ActiveRecord::Migration[8.1]
 def change
    create_table :saved_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url, null: false

      t.timestamps
    end

    # Per-user dedupe (exact-match URL). This enforces isolation and avoids duplicates
    # without attempting canonical URL normalization.
    add_index :saved_items, [ :user_id, :url ], unique: true
  end
end
