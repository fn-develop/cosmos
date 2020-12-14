# == Schema Information
#
# Table name: line_message_notify_settings
#
#  id               :bigint           not null, primary key
#  norify_time_from :integer          default(0)
#  norify_time_to   :integer          default(0)
#  notify_cycle     :integer          default(0)
#  notify_enabled   :boolean          default(TRUE)
#  notify_target    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer          not null
#
class LineMessageNotifySetting < ApplicationRecord
  belongs_to :company

  NOTIFY_CYCLE = { '都度': 1, '10分': 10, '30分': 30, '1時間': 60 }
  NOTIFY_TAEGET = { 'オーナー': 'owner', 'スタッフ': 'staff', '両方': 'all' }

  def notify_new_line_message(system_url)
    now = DateTime.now
    return unless active_time?(now) && cycle_ok?(now)

    self.updated_at = now
    self.save

    unread_line_message_count = self.company.line_message_logs.where(checked: false).count

    line_user_ids = []
    case self.notify_target
    when 'owner'
      self.company.users.where(role: :owner).each do |user|
        line_user_id = user.line_user_id
        line_user_ids.push line_user_id if line_user_id.present?
      end
    when 'staff'
      self.company.users.where(role: :staff).each do |user|
        line_user_id = user.line_user_id
        line_user_ids.push line_user_id if line_user_id.present?
      end
    when 'all'
      self.company.users.where(role: [:owner, :staff]).each do |user|
        line_user_id = user.line_user_id
        line_user_ids.push line_user_id if line_user_id.present?
      end
    end

    send_message = {
     type: Const::LineMessage::Type::TEXT,
     text: "#{unread_line_message_count}件の未読メッセージがあります。 #{ system_url }",
    }

    client.multicast(line_user_ids, send_message) if line_user_ids.present?
  end

  def active_time?(now)
    return false unless self.company.is_notify_unread_line_message_existance? && self.notify_enabled?
    return false unless now.hour >= self.norify_time_from && now.hour <= self.norify_time_to
    true
  end

  def cycle_ok?(now)
    return false if (now.to_i - self.updated_at.to_i) < self.notify_cycle.minute.to_i
    true
  end

  private def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = self.company.try(:line_channel_secret)
      config.channel_token  = self.company.try(:line_channel_token)
    }
  end
end
