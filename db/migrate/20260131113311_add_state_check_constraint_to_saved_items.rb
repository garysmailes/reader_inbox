class AddStateCheckConstraintToSavedItems < ActiveRecord::Migration[8.1]
def up
    # Defensive cleanup: if anything ever inserted an unexpected value,
    # normalize it back to the canonical default.
    execute <<~SQL
      UPDATE saved_items
      SET state = 'unread'
      WHERE state IS NULL
         OR state NOT IN ('unread', 'viewed', 'read', 'archived')
    SQL

    add_check_constraint(
      :saved_items,
      "state IN ('unread', 'viewed', 'read', 'archived')",
      name: "saved_items_state_allowed"
    )
  end

  def down
    remove_check_constraint :saved_items, name: "saved_items_state_allowed"
  end
end
