class AddIsCalendarFeatureToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :is_calendar_feature, :boolean, default: false, after: :line_channel_token
  end
end
