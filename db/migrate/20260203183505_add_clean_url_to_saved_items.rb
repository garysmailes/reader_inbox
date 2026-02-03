class AddCleanUrlToSavedItems < ActiveRecord::Migration[8.1]
  class MigrationSavedItem < ApplicationRecord
    self.table_name = "saved_items"
  end

  def up
    add_column :saved_items, :clean_url, :string

    MigrationSavedItem.reset_column_information

    say_with_time "Backfilling saved_items.clean_url from saved_items.url" do
      MigrationSavedItem.find_in_batches(batch_size: 1000) do |batch|
        batch.each do |item|
          raw = item.url.to_s.strip
          next if raw.blank?

          clean = raw
                    .sub(/\Ahttps?:\/\//, "")
                    .sub(/\Awww\./, "")
          clean = raw if clean.blank?

          item.update_columns(clean_url: clean)
        end
      end
    end

    # Ensure the column is always present (URL is required, so clean_url should always be derivable).
    execute "UPDATE saved_items SET clean_url = '' WHERE clean_url IS NULL"
    change_column_null :saved_items, :clean_url, false
  end

  def down
    remove_column :saved_items, :clean_url
  end
end
