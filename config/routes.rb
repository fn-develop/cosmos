Rails.application.routes.draw do
  resources :companies
  resources :collection_items
  resources :collections
  resources :items

  root to: 'public/homes#index'

  # deviseのログイン機能を自前のコントローラーで管理
  devise_for :users, path: '/:company_code/', path_names: {
    # devise のルーティングをデフォルトから変更する設定
    sign_out: 'logout',
    sign_in: 'login',
  },
  controllers: {
    sessions: 'auth/sessions'
  }

  scope '/:company_code/' do
    resources :customers
  end

  scope module: :public do
    resources :homes
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
