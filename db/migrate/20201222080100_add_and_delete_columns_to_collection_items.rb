class AddAndDeleteColumnsToCollectionItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :collection_items, :item_type
    add_column :collection_items, :key, :string, after: :item_id
    add_column :collection_items, :value, :string, after: :key
  end
end
