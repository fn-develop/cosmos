class Ability
  include CanCan::Ability

  def initialize(user)
    # ログイン/アウトは全てのユーザーで許可
    can :manage, :session
    can :read, :home

    user ||= User.new

    # User.roles => { guest: 0, customer: 1, staff: 2, owner: 3, system_admin: 9 }
    send("#{ user.try(:role) || 'guest' }_ability", user)
  end

  private

    # ゲスト
    def guest_ability(user)
      can [:new_with_line, :create_with_line], :customer
      can :read, Company
    end

    # 顧客
    def customer_ability(user)
      can [:new_with_line, :create_with_line], :customer
      can :read, Company
    end

    # スタッフ
    def staff_ability(user)
      can :manage, :customer
      can :manage, Customer, company: user.company
      can :read, Company, company: user.company
      can :manage, :user
      can :manage, User, company: user.company
      can :read, :setting
      can :read, :item, company: user.company
    end

    # 店舗オーナー
    def owner_ability(user)
      can :manage, :customer
      can :manage, Customer, company: user.company
      can :manage, Company, id: user.company.id
      can :manage, :user
      can :manage, User, company: user.company
      can :manage, :setting
      can :manage, :item, company: user.company
    end

    # システム管理者
    def system_admin_ability(user)
      can :manage, :all
      can :access, :rails_admin
    end
end
