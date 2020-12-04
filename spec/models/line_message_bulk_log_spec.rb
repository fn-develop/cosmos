# == Schema Information
#
# Table name: line_message_bulk_logs
#
#  id                :bigint           not null, primary key
#  disabled_user_ids :text(65535)
#  enabled_user_ids  :text(65535)
#  message           :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  company_id        :integer          not null
#
require 'rails_helper'

RSpec.describe LineMessageBulkLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
