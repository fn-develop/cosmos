# == Schema Information
#
# Table name: items
#
#  id         :bigint           not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#
# Indexes
#
#  index_items_on_company_id  (company_id)
#
class Item < ApplicationRecord
end
