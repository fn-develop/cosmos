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

  scope '/:company_code/', constraints: { company_code: /[a-z]+/ } do
    resources :customers do
      get  'new/:reply_token', to: 'customers#new', as: :new, on: :collection
      get  'new_line_message', to: 'customers#new_line_message', on: :member
      post 'send_line_message', to: 'customers#send_line_message', on: :member
    end

    scope module: :public do
      resources :homes, path: ''
    end

    namespace 'api' do
      namespace 'v1' do
        resource :line do
          post 'callback', to: 'lines#callback'
        end
      end
    end
  end

  mount RailsAdmin::Engine => '/0', as: 'rails_admin'
end
