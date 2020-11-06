class AddLineChaneelToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :line_channel_secret, :string, null: true, after: :enabled
    add_column :companies, :line_channel_token, :string, null: true, after: :line_channel_secret
  end
end
