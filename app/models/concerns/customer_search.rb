class CustomerSearch
  include ActiveModel::Model

  DEFAULT_PER = 20

  attr_accessor :company
  # 既定権限
  attr_accessor :current_ability
  # ページ指定
  attr_accessor :page
  # 一覧表示上限
  attr_accessor :per
  # 検索条件：顧客名
  attr_accessor :name

  def search
    self.per ||= DEFAULT_PER
    return customers.order(id: 'DESC').page(self.page).per(self.per)
  end

  def customers
    c = get_base_rel

    if self.name.present?
      c = c.where('name LIKE ?', "%#{ self.name }%").or(c.where('name_kana LIKE ?', "%#{ self.name }%"))
    end

    c
  end

  private
    def get_base_rel
      company.customers.includes(user: [:line_message_logs]).accessible_by(self.current_ability)
    end
end