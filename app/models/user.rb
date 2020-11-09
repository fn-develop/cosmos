# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :integer          default("customer"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable, :validatable
  devise :database_authenticatable, :rememberable

  has_many :company_users, dependent: :destroy
  has_many :companies, through: :company_users
  has_many :line_message_logs
  has_many :staff_line_mseege_logs, class_name: 'LineMessageLog', foreign_key: 'staff_id'
  has_one  :line_user, dependent: :destroy
  has_one  :customer, dependent: :destroy

  enum role: { customer: 0, staff: 1, owner: 2 }

  # スタッフ以上の権限を持つユーザーかどうか
  def over_staff_or_more?
    (self.role_before_type_cast > 0 || self.admin?)
  end

  def unread_user_line_message?
    self.line_message_logs.where(checked: false).present?
  end
end
