Rails.application.routes.draw do
  resources :companies
  resources :collection_items
  resources :collections
  resources :option_for_items
  resources :items
  root to: 'customers#index'

  resources :customers

  # deviseのログイン機能を自前のコントローラーで管理
  devise_for :users, path: '', path_names: {
    # devise のルーティングをデフォルトから変更する設定
    sign_in: 'login',
    sign_out: 'logout',
  },
  controllers: {
    sessions: 'auth/sessions'
  }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
