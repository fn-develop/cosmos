# == Schema Information
#
# Table name: calendar_settings
#
#  id                       :bigint           not null, primary key
#  is_open                  :boolean          default(FALSE)
#  open_collection_item_ids :text(65535)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  company_id               :integer          not null
#
FactoryBot.define do
  factory :calendar_setting do
    
  end
end
