class Ability
  include CanCan::Ability

  def initialize(user)
    # ログイン/アウトは全てのユーザーで許可
    can :manage, :session
    can :read, :home

    user ||= User.new

    if user.admin?
      can :manage, :all
      can :access, :rails_admin
    else
      # User.roles => { customer: 0, staff: 1, owner: 2 }
      send("#{ user.try(:role) || 'guest' }_ability", user)
    end
  end

  private

    # ゲスト
    def guest_ability(user)
      can [:new_with_line, :create], :customer
      can :read, Company, id: user.companies.pluck(:id)
    end

    # 顧客
    def customer_ability(user)
      can [:new_with_line, :create], :customer
      can :read, Company, id: user.companies.pluck(:id)
    end

    # スタッフ
    def staff_ability(user)
      can :manage, :customer
      can :manage, Customer, user_id: User.where(company_id: user.companies.pluck(:id))
      can :manage, Company, id: user.companies.pluck(:id)
    end

    # 管理者
    def admin_ability(user)
      can :manage, :customer
      can :manage, Customer, user_id: User.where(company_id: user.companies.pluck(:id))
      can :manage, Company, id: user.companies.pluck(:id)
    end
end
