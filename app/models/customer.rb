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
#  company_id  :integer          not null
#  user_id     :integer
#
# Indexes
#
#  index_customers_on_company_id  (company_id)
#
class Customer < ApplicationRecord
  belongs_to :user, required: false
  belongs_to :company

  enum gender: { men: 0, women: 1 }

  attr_accessor :tel_number1
  attr_accessor :tel_number2
  attr_accessor :tel_number3

  attr_accessor :postal_code1
  attr_accessor :postal_code2

  after_find :split_tel_number, :split_postal_code
  before_validation :join_tel_numbers, :join_postal_codes

  validates :name, presence: true
  validates :name_kana, presence: true
  validates :gender, presence: true
  validates :tel_number, presence: true, length: { is: 11 }, numericality: { only_integer: true }
  validates :postal_code, presence: true, length: { is: 7 }, numericality: { only_integer: true }

  def line?
    self.user.try(:line_user).present?
  end

  def formatted_tel_number
    self[:tel_number].gsub(/(\d{3})(\d{4})(\d{4})/, '\1-\2-\3')
  end

  def formatted_postal_code
    self[:postal_code].gsub(/(\d{3})(\d{4})/, '\1-\2')
  end

  private
    def split_tel_number
      self.tel_number1, self.tel_number2, self.tel_number3 = self.formatted_tel_number.split('-')
    end

    def join_tel_numbers
      self.tel_number = self.tel_number1.to_s + self.tel_number2.to_s + self.tel_number3.to_s
    end

    def split_postal_code
      self.postal_code1, self.postal_code2 = self.formatted_postal_code.split('-')
    end

    def join_postal_codes
      self.postal_code = self.postal_code1.to_s + self.postal_code2.to_s
    end
end
