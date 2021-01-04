class DeleteCollectionIdToCollectionItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :collection_items, :collection_id
  end
end
