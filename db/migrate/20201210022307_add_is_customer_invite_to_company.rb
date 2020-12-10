class AddIsCustomerInviteToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :is_inviting_feature, :boolean, default: true, after: :line_channel_token
  end
end
