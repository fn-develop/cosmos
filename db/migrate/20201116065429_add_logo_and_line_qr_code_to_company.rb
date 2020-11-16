class AddLogoAndLineQrCodeToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :logo, :string, after: :enabled
    add_column :companies, :line_qr_code, :string, after: :logo
  end
end
