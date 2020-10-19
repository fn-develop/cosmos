class CreateLineUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :line_users do |t|
      t.intege :company_id
      t.integer :user_id
      t.string :line_user_id
      t.string :reply_token
      t.text :request_json

      t.timestamps
    end
  end
end
