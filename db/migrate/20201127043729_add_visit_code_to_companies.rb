class AddVisitCodeToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :visit_confirmation_code, :string, default: '0000', after: :logo
  end
end
