class CreateCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :collections do |t|
      t.integer :company_id
      t.string :code
      t.string :name
      t.integer :sort_order, limit: 3
      t.boolean :enabled

      t.timestamps
    end

    add_index :collections, :company_id
  end
end
