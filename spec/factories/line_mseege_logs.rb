# == Schema Information
#
# Table name: line_mseege_logs
#
#  id         :bigint           not null, primary key
#  code       :string(255)
#  message    :string(255)
#  month      :string(255)
#  year       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#  staff_id   :integer
#  user_id    :string(255)
#
# Indexes
#
#  index_line_mseege_logs_on_code                    (code)
#  index_line_mseege_logs_on_company_id_and_user_id  (company_id,user_id)
#  index_line_mseege_logs_on_year_and_month          (year,month)
#
FactoryBot.define do
  factory :line_mseege_log do
    
  end
end
