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
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "TEST#{n}@example.com"}
  end
end
