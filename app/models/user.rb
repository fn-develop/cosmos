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
#  role                   :integer          default("guest"), not null
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
  devise :validatable, password_length: 8..20

  belongs_to :company

  has_many :line_message_logs, dependent: :destroy
  has_many :staff_line_mseege_logs, class_name: 'LineMessageLog', foreign_key: 'staff_id', dependent: :destroy
  has_one :customer, dependent: :nullify

  enum role: { guest: 0, customer: 1, staff: 2, owner: 3, system_admin: 9 }

  # スタッフ以上の権限を持つユーザーかどうか
  def over_staff_or_more?
    (self.role_before_type_cast > 0)
  end

  def unread_user_last_line_message
    @last_message ||= self.line_message_logs.where(checked: false).last
  end

  def unread_user_line_message?
    unread_user_last_line_message.present?
  end

  def unread_user_last_line_message_content
    return if unread_user_last_line_message.blank?
    sended_time = unread_user_last_line_message.created_at
    sended_time.strftime("%m/%d %H:%M")
  end

  #### START EMAIL 重複OK ######
  # Deviseを使うと、問答無用でemailがユニーク扱いになる。
  # それだと論理削除した際に再登録できないので、一旦emailに関する検証を削除する
  # https://gist.github.com/brenes/4503386
  _validators.delete(:email)
  _validate_callbacks.each do |callback|
    if callback.raw_filter.respond_to? :attributes
      callback.raw_filter.attributes.delete :email
    end
  end

  # emailのバリデーションを定義し直す
  validates :email, presence: true
  validates_format_of :email, with: Devise.email_regexp, if: :email_changed?
  validates_uniqueness_of :email, scope: :company_id, if: :email_changed?
  #### END EMAIL 重複OK ######
end
