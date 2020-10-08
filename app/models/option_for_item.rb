# == Schema Information
#
# Table name: option_for_items
#
#  id         :bigint           not null, primary key
#  code       :string(255)
#  enabled    :boolean
#  item_type  :integer
#  name       :string(255)
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer
#
class OptionForItem < ApplicationRecord
end
