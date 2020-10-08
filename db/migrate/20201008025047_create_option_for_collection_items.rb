class CreateOptionForCollectionItems < ActiveRecord::Migration[6.0]
  def change
    create_table :option_for_collection_items do |t|
      t.integer :collection_item_id
      t.string :code
      t.string :name
      t.integer :sort_order, limit: 3
      t.boolean :enabled

      t.timestamps
    end
  end
end
