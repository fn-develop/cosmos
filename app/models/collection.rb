# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  code       :string(255)
#  enabled    :boolean
#  name       :string(255)
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#
# Indexes
#
#  index_collections_on_company_id  (company_id)
#
class Collection < ApplicationRecord
end
