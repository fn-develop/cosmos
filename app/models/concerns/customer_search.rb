class CustomerSearch
  include ActiveModel::Model

  VISITED_OVER_LIST = [
    ['〜1ヶ月', '0'],
    ['1ヶ月超', '1'],
    ['2ヶ月超', '2'],
    ['3ヶ月超', '3'],
    ['4ヶ月超', '4'],
    ['6ヶ月超', '5'],
  ].freeze

  DEFAULT_PER = 100

  attr_accessor :company
  # 既定権限
  attr_accessor :current_ability
  # ページ指定
  attr_accessor :page
  # 一覧表示上限
  attr_accessor :per
  # 検索条件：顧客名
  attr_accessor :name
  # 検索条件：年齢(以上)
  attr_accessor :from_age
  # 検索条件：年齢(以下)
  attr_accessor :to_age
  # 検索条件：性別
  attr_accessor :gender
  # 検索条件：LINE登録済
  attr_accessor :line_registed
  # 検索条件：LINE未読
  attr_accessor :unread_line
  # 検索条件：最終来店
  attr_accessor :visited_over

  def search
    self.per ||= DEFAULT_PER
    return customers.order(id: 'DESC').page(self.page).per(self.per)
  end

  def search_for_bulk_line_messages
    user_ids = company.users.where("line_user_id IS NOT NULL AND line_user_id <> ''").pluck(:id)
    customers.where(user_id: user_ids)
  end

  def search_for_sms
    customers.select{ |c| c.have_mobile_phone_number? }
  end

  def customers
    c = get_base_rel

    if self.from_age.present?
      c = c.where('birthday <= ?', Date.today - self.from_age.to_i.year)
    end

    if self.to_age.present?
      c = c.where('birthday > ?', Date.today - self.to_age.to_i.year - 1.year)
    end

    if self.name.present?
      c = c.where('name LIKE ?', "%#{ self.name }%").or(c.where('name_kana LIKE ?', "%#{ self.name }%"))
    end

    if self.gender.present?
      c = c.where(gender: self.gender)
    end

    if self.line_registed.present?
      user_ids = company.users.where("line_user_id IS NOT NULL AND line_user_id <> ''").pluck(:id)
      c = c.where(user_id: user_ids)
    end

    if self.unread_line.present?
      line_message_log_user_ids = self.company.line_message_logs.where(checked: false).pluck(:user_id)
      c = c.where(user_id: line_message_log_user_ids)
    end

    if self.visited_over.present?
      c = c.where('ymd_num IS NOT NULL')
      case self.visited_over
      when VISITED_OVER_LIST[0][1]
        conditon_ymd = (Date.today - 1.month).strftime('%Y%m%d').to_i
        c = c.where('ymd_num > ?', conditon_ymd)
      else
        conditon_ymd = (Date.today - (self.visited_over.to_i).month).strftime('%Y%m%d').to_i
        c = c.where('ymd_num < ?', conditon_ymd)
      end
    end

    c
  end

  def inputed?
    self.name.present? || self.from_age.present? || self.to_age.present? || self.gender.present? || self.line_registed.present? || self.unread_line.present? || self.visited_over.present?
  end

  private
    def get_base_rel
      company.customers.includes(user: [:line_message_logs]).accessible_by(self.current_ability)
    end
end
