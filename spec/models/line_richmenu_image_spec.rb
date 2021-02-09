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
require 'rails_helper'

RSpec.describe LineRichmenuImage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
