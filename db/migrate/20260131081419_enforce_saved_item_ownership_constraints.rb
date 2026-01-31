class EnforceSavedItemOwnershipConstraints < ActiveRecord::Migration[8.1]
 def change
    # 1) user ownership must be required (NOT NULL)
    if column_exists?(:saved_items, :user_id)
      change_column_null :saved_items, :user_id, false
    end

    # 2) enforce referential integrity (FK saved_items.user_id -> users.id)
    unless foreign_key_exists?(:saved_items, :users)
      add_foreign_key :saved_items, :users
    end

    # 3) per-user URL uniqueness (user_id + url)
    unless index_exists?(:saved_items, [:user_id, :url], unique: true)
      add_index :saved_items, [:user_id, :url], unique: true
    end

    # 4) support canonical inbox ordering: per-user, most recently added first
    # Index supports: WHERE user_id = ? ORDER BY created_at DESC
    unless index_exists?(:saved_items, [:user_id, :created_at])
      add_index :saved_items, [:user_id, :created_at], order: { created_at: :desc }
    end
  end
end
