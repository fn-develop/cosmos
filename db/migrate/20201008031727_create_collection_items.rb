class CreateCollectionItems < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_items do |t|
      t.integer :collection_id
      t.integer :item_id
      t.integer :item_type
      t.integer :sort_order, limit: 3
      t.boolean :enabled

      t.timestamps
    end
  end
end
