class AddLimitLineMessageCountToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :limit_line_message_count, :integer, default: 1000, after: :logo
  end
end
