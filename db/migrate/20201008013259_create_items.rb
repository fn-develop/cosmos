class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.integer :company_id
      t.integer :item_type, limit: 2
      t.string :code
      t.string :name

      t.timestamps
    end

    add_index :items, :company_id
  end
end
