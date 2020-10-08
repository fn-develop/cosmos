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
  has_many :company_users, dependent: :destroy
  has_many :users, through: :company_users
  has_many :items, dependent: :destroy
  has_many :collections, dependent: :destroy
end
