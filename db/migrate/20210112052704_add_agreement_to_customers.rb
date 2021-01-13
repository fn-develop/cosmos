class AddAgreementToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :agreement, :boolean, default: false, after: :id
    add_column :companies, :is_for_profit, :boolean, default: true, after: :line_channel_token
  end
end
