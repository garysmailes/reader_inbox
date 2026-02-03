class AddMetadataStatusToSavedItems < ActiveRecord::Migration[8.1]
 class MigrationSavedItem < ApplicationRecord
    self.table_name = "saved_items"
  end

  def up
    add_column :saved_items, :metadata_status, :string, null: false, default: "pending"

    MigrationSavedItem.reset_column_information

    say_with_time "Backfilling saved_items.metadata_status" do
      MigrationSavedItem.find_in_batches(batch_size: 1000) do |batch|
        batch.each do |item|
          status =
            if item.fetched_title.present? || item.domain.present?
              "succeeded"
            else
              "pending"
            end

          item.update_columns(metadata_status: status)
        end
      end
    end

    add_check_constraint(
      :saved_items,
      "metadata_status IN ('pending', 'succeeded', 'failed')",
      name: "saved_items_metadata_status_allowed"
    )
  end

  def down
    remove_check_constraint :saved_items, name: "saved_items_metadata_status_allowed"
    remove_column :saved_items, :metadata_status
  end
end
