class CreateLineRichmenuImages < ActiveRecord::Migration[6.0]
  def change
    create_table :line_richmenu_images do |t|
      t.integer :company_id, null: false
      t.string  :image_file
      t.string  :memo

      t.timestamps
    end
  end
end
