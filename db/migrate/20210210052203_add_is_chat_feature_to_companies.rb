class AddIsChatFeatureToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :is_chat_feature, :boolean, default: false, after: :is_calendar_feature
  end
end
