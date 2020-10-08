class CreateCompanyUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :company_users do |t|
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end

    add_index :company_users, :company_id
    add_index :company_users, :user_id
  end
end
