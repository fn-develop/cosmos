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
class LineRichmenuImage < ApplicationRecord
  mount_uploader :image_file, LineRichmenuImageUploader

  belongs_to :company

  validates :image_file, presence: true

  def base64_image(size)
    file = self.image_file.try(size)
    encode_base64_image_file(file)
  end

  def encode_base64_image_file(file = nil)
    w_file = file || self.image_file
    "data:#{ w_file.content_type };base64,#{ Base64.strict_encode64(w_file.read) }"
  end
end
