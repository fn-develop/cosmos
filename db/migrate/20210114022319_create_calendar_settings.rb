class CreateCalendarSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_settings do |t|
      t.integer :company_id,               null:    false
      t.boolean :is_open,                  default: false
      t.text    :open_collection_item_ids, array:   true

      t.timestamps
    end
  end
end
