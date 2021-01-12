class AddTypeForToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :type_for, :string, default: '', after: :id
  end
end
