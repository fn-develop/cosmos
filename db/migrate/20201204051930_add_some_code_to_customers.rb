class AddSomeCodeToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :introducer_id, :integer, after: :id
    add_column :customers, :invite_code, :string, after: :introducer_id
  end
end
