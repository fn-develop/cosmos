Rails.application.routes.draw do
  # deviseのログイン機能を自前のコントローラーで管理
  devise_for :users, controllers: {
    sessions: 'home/sessions'
  }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
