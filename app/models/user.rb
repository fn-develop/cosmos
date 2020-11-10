# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :integer          default("customer"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id             :integer          not null
#  line_user_id           :string(255)
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
  belongs_to :company

  has_many :line_message_logs
  has_many :staff_line_mseege_logs, class_name: 'LineMessageLog', foreign_key: 'staff_id'
  has_one :customer, dependent: :destroy

  enum role: { guest: 0, customer: 1, staff: 2, owner: 3, system_admin: 9 }

  # スタッフ以上の権限を持つユーザーかどうか
  def over_staff_or_more?
    (self.role_before_type_cast > 0)
  end

  def unread_user_line_message?
    self.line_message_logs.where(checked: false).present?
  end
end
