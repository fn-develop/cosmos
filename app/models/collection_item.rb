# == Schema Information
#
# Table name: collection_items
#
#  id            :bigint           not null, primary key
#  enabled       :boolean
#  item_type     :integer
#  sort_order    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :integer
#  item_id       :integer
#
class CollectionItem < ApplicationRecord
  belongs_to :collection
  belongs_to :item
end
