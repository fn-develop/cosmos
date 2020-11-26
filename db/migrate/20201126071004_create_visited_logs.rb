class CreateVisitedLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :visited_logs do |t|
      t.integer :company_id, null: false
      t.integer :customer_id
      t.string  :year
      t.string  :month
      t.string  :day
      t.string  :visit_token

      t.boolean :enabled, default: false
      t.timestamps
    end

    add_index :visited_logs, :company_id, unique: false
    add_index :visited_logs, :year, unique: false
    add_index :visited_logs, :month, unique: false
  end
end
