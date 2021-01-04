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
      can [:new_with_line, :new_with_line_non_tel_number, :create_with_line, :visit_user_qr_code], :customer
      can :read, Company
      if user.company.try(:is_calendar_feature?)
        can :read, :calendar
      end
    end

    # 顧客
    def customer_ability(user)
      can [:new_with_line, :new_with_line_non_tel_number, :create_with_line], :customer
      can :read, Company
      if user.company.try(:is_calendar_feature?)
        can :read, :calendar
      end
    end

    # スタッフ
    def staff_ability(user)
      can :manage, :customer
      can :manage, Customer, company: user.company
      can :read, Company, company: user.company
      can :manage, :user
      can :manage, User, company: user.company
      can :read, :setting
      can :manage, :bulk_line_message
      can :manage, :calendar
      can :manage, :visited_log
    end

    # 店舗オーナー
    def owner_ability(user)
      can :manage, :customer
      can :manage, Customer, company: user.company
      can :manage, Company, id: user.company.id
      can :manage, :user
      can :manage, User, company: user.company
      can :manage, :setting
      can :manage, :bulk_line_message
      if user.company.try(:is_calendar_feature?)
        can :manage, :calendar
      end
      can :manage, :visited_log
      can :manage, :staff
    end

    # システム管理者
    def system_admin_ability(user)
      can :manage, :all
      can :access, :rails_admin
    end
end
