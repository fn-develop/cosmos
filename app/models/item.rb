# == Schema Information
#
# Table name: items
#
#  id         :bigint           not null, primary key
#  code       :string(255)
#  name       :string(255)
#  sub_code   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#
# Indexes
#
#  index_items_on_company_id  (company_id)
#
class Item < ApplicationRecord
  belongs_to :company
  has_many :collection_items

  VALID_CODE_REGEX = /\A[a-z\_]+\z/ # 半角英字
  validates :code, presence: true, length: { in: 1..20 }, format: { with: VALID_CODE_REGEX, message: 'は半角英文字と「_」のみが使えます' }
  validates :name, presence: true, length: { in: 1..20 }

  before_destroy :should_not_destroy_if_collection_items

  private

    def should_not_destroy_if_collection_items
      if self.collection_items.present?
        # 公開済みのブログは削除できない
        throw :abort
      end
    end

end
