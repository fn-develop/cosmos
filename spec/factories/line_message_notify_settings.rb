# == Schema Information
#
# Table name: line_message_notify_settings
#
#  id                    :bigint           not null, primary key
#  auto_message_off_time :string(255)      default("")
#  auto_message_on_time  :string(255)      default("")
#  norify_time_from      :integer          default(0)
#  norify_time_to        :integer          default(0)
#  notify_cycle          :integer          default(0)
#  notify_enabled        :boolean          default(TRUE)
#  notify_target         :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :integer          not null
#
FactoryBot.define do
  factory :line_message_notify_setting do
    
  end
end
