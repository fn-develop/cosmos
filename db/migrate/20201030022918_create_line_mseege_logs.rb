class CreateLineMseegeLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :line_mseege_logs  do |t|
      t.integer :company_id
      t.string  :line_user_id
      t.string  :message
      t.string  :code
      t.string  :year
      t.string  :month

      t.timestamps
    end

    add_index :line_mseege_logs, [:company_id, :line_user_id], unique: false
    add_index :line_mseege_logs, :code
    add_index :line_mseege_logs, [:year, :month], unique: false
  end
end
