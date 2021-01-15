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
class CalendarSetting < ApplicationRecord
  serialize :open_collection_item_ids, Array

  belongs_to :company

  def open_collection_items
    item = self.company.items.find_by(code: 'calendar', sub_code: 'select_option', name: 'event_type')
    item.try(:collection_items).to_a
  end
end
