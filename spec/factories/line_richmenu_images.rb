# == Schema Information
#
# Table name: line_richmenu_images
#
#  id         :bigint           not null, primary key
#  image_file :string(255)
#  memo       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#
FactoryBot.define do
  factory :line_richmenu_image do
    
  end
end
