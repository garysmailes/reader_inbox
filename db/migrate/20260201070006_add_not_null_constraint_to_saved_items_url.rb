class AddNotNullConstraintToSavedItemsUrl < ActiveRecord::Migration[8.1]
  def up
    # Safety check: do not silently coerce bad data
    null_count = execute(<<~SQL).first["count"].to_i
      SELECT COUNT(*) AS count
      FROM saved_items
      WHERE url IS NULL
    SQL

    if null_count > 0
      raise ActiveRecord::IrreversibleMigration,
            "Cannot add NOT NULL constraint to saved_items.url: #{null_count} rows have NULL url"
    end

    change_column_null :saved_items, :url, false
  end

  def down
    change_column_null :saved_items, :url, true
  end

end
