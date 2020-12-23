# == Schema Information
#
# Table name: collection_items
#
#  id         :bigint           not null, primary key
#  enabled    :boolean
#  key        :string(255)
#  sort_order :integer
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer
#
class CollectionItem < ApplicationRecord
  belongs_to :item
  has_many :option_for_collection_items, dependent: :destroy

  VALID_CODE_REGEX = /\A[a-z\_]+\z/ # 半角英字とアンダーバー
  validates :key, presence: true, length: { in: 1..20 }
  validates :value, presence: true, length: { in: 1..20 }, format: { with: VALID_CODE_REGEX, message: 'は半角英文字と「_」のみが使えます' }, uniqueness: { scope: :item_id }
  validates :sort_order, presence: true
  validates :enabled, inclusion: [true, false]
end
