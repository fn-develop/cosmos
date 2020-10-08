# == Schema Information
#
# Table name: option_for_collection_items
#
#  id                 :bigint           not null, primary key
#  code               :string(255)
#  enabled            :boolean
#  name               :string(255)
#  sort_order         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  collection_item_id :integer
#
class OptionForCollectionItem < ApplicationRecord
  belongs_to :collection_item
end
