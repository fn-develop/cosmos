# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  image                  :string(255)
#  line_display_name      :string(255)
#  line_image_url         :string(255)
#  line_status_message    :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :integer          default("guest"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id             :integer          not null
#  line_richmenu_id       :string(255)
#  line_user_id           :string(255)
#
# Indexes
#
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  mount_uploader :image, InsiteImageUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable, :validatable
  devise :database_authenticatable, :rememberable
  devise :validatable, password_length: 8..20

  belongs_to :company

  has_many :line_message_logs, dependent: :destroy
  has_many :staff_line_mseege_logs, class_name: 'LineMessageLog', foreign_key: 'staff_id', dependent: :destroy
  has_many :staff_line_mseege_bulk_logs, class_name: 'LineMessageBulkLog', foreign_key: 'staff_id', dependent: :nullify
  has_one :customer, dependent: :nullify
  accepts_nested_attributes_for :customer, update_only: true
  has_many :calendar_joined_users, dependent: :destroy
  has_many :calendars, through: :calendar_joined_users

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

  def reset_line_info
    return if self.line_user_id.blank?
    client = LineMessage.new(company: company).client
    profile = client.get_profile(self.line_user_id)
    profile_body = profile.try(:body)
    if profile_body.present?
      profile_has = JSON.parse(profile.body)
      self.line_display_name = profile_has['displayName']
      self.line_image_url = profile_has['pictureUrl']
      self.remote_image_url = profile_has['pictureUrl']
      self.line_status_message = profile_has['statusMessage']
      self.save(validate: false)
    end
  end

  def base64_image(size)
    file = self.image.try(size)
    "data:#{ file.content_type };base64,#{ Base64.strict_encode64(file.read) }"
  end

  def name
    (self.customer.try(:name) || self.line_display_name || self.company.try(:name)).to_s
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

  def adjust_one_button_insite_menu(uri, file, user)
    create_one_button_insite_menu(uri, file, user)
  end

  def create_one_button_insite_menu(uri, file, user)
    rich_menu = LineMenu::one_button_insite_rich_menu_has(uri)
    response = client.create_rich_menu(rich_menu)

    response_code = response.code.to_i
    if (response_code >= 200 && response_code < 300)
      rich_menu_id = JSON.parse(response.body)['richMenuId']
      response = client.create_rich_menu_image(rich_menu_id, file)

      response_code = response.code.to_i
      if (response_code >= 200 && response_code < 300)
        response = client.link_user_rich_menu(user.line_user_id, rich_menu_id)
        response_code = response.code.to_i
        if (response_code >= 200 && response_code < 300)
          if user.line_richmenu_id.present?
            client.delete_rich_menu(user.line_richmenu_id)
          end
          user.line_richmenu_id = rich_menu_id
          user.save!(validate: false)
        else
          client.delete_rich_menu(rich_menu_id)
          return false
        end
      else
        client.delete_rich_menu(rich_menu_id)
        return false
      end
    else
      return false
    end

    true
  end

  private
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = self.company.try(:line_channel_secret)
        config.channel_token  = self.company.try(:line_channel_token)
      }
    end
end
