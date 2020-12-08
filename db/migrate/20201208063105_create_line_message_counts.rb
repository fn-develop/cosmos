class CreateLineMessageCounts < ActiveRecord::Migration[6.0]
  def change
    create_table :line_message_counts do |t|
      t.integer :company_id, null: false
      t.integer :total, null: false, dafault: 0
      t.string  :year, null: false
      t.string  :month, null: false

      t.timestamps
    end
  end
end
