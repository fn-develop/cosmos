class AddCompanyIdToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :company_id, :integer, null: false, after: :id

    add_index :customers, :company_id
  end
end
