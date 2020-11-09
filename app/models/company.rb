# == Schema Information
#
# Table name: companies
#
#  id                  :bigint           not null, primary key
#  code                :string(255)
#  enabled             :boolean
#  line_channel_secret :string(255)
#  line_channel_token  :string(255)
#  name                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Company < ApplicationRecord
  has_many :company_users, dependent: :destroy
  has_many :users, through: :company_users
  has_many :customers, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :line_users, dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { in: 2..10 }, format: { with: /\A[a-z]+\z/, message: "英文字のみが使用できます" }
  validates :name, presence: true, length: { in: 1..50 }
end
