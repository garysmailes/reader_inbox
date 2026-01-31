class BackfillSavedItemsStateToUnread < ActiveRecord::Migration[8.1]
 disable_ddl_transaction!

  def up
    # Backfill only missing/blank states.
    # Do NOT infer viewed/read/archived from any historical data.
    execute <<~SQL
      UPDATE saved_items
      SET state = 'unread'
      WHERE state IS NULL OR btrim(state) = ''
    SQL
  end

  def down
    # Irreversible: we can't know which rows were originally NULL/blank.
    # Intentionally no-op.
  end
end
