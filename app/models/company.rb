# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  code       :string(255)
#  enabled    :boolean
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
end
