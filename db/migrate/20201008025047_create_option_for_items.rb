class CreateOptionForItems < ActiveRecord::Migration[6.0]
  def change
    create_table :option_for_items do |t|
      t.integer :item_id
      t.integer :item_type
      t.string :code
      t.string :name
      t.integer :sort_order
      t.boolean :enabled

      t.timestamps
    end
  end
end
