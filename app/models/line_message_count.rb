# == Schema Information
#
# Table name: line_message_counts
#
#  id         :bigint           not null, primary key
#  month      :string(255)      not null
#  total      :integer          not null
#  year       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#
class LineMessageCount < ApplicationRecord
  belongs_to :company
end
