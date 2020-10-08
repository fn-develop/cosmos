# == Schema Information
#
# Table name: customers
#
#  id          :bigint           not null, primary key
#  address1    :string(255)
#  address2    :string(255)
#  birthday    :date
#  city        :string(255)
#  gender      :integer
#  name        :string(255)
#  name_kana   :string(255)
#  postal_code :string(255)
#  prefecture  :string(255)
#  tel_number  :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Customer < ApplicationRecord
end