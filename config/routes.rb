Rails.application.routes.draw do

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
    resources :customers, path: 'members' do
      get  'new_with_line/:line_user_id', to: 'customers#new_with_line', as: :new_with_line, on: :collection
      post 'new_with_line_non_tel_number', to: 'customers#new_with_line_non_tel_number', as: :new_with_line_non_tel_number, on: :collection
      get  'new_line_message', to: 'customers#new_line_message', on: :member
      post 'send_line_message', to: 'customers#send_line_message', on: :member
      get  'new_sms_message', to: 'customers#new_sms_message', on: :member
      post 'send_sms_message', to: 'customers#send_sms_message', on: :member
      post 'create_with_line', to: 'customers#create_with_line', on: :collection
      get 'reload_notify_area', to: 'customers#reload_notify_area', on: :collection
      get 'visit_user_qr_code/:visit_token', to: 'customers#visit_user_qr_code', on: :collection, as: :visit_user_qr_code
      get 'on_visited/:line_user_id', to: 'customers#on_visited', on: :collection
      get 'confirm_visited/:visit_token', to: 'customers#confirm_visited', on: :collection, as: :confirm_visited
      get 'xhr_get_customers', to: 'customers#xhr_get_customers', on: :collection, as: :xhr_get_customers, defaults: { format: 'js' }
      post 'update_introducer', to: 'customers#update_introducer', on: :member, as: :update_introducer
      get 'xhr_get_base64_message_image', to: 'customers#xhr_get_base64_message_image', on: :member, as: :xhr_get_base64_message_image
      post 'reset_line_info', to: 'customers#reset_line_info', on: :member, as: :reset_line_info
      get 'recent_message_index', to: 'customers#recent_message_index', on: :collection

      scope module: :customer do
        resources :visited_logs
      end
    end

    resources :users do
      post 'reset_line_info', to: 'users#reset_line_info', on: :member
      post 'adjust_rich_menu/:line_rich_menu_image_id', to: 'users#adjust_rich_menu', on: :member, as: :adjust_rich_menu
    end

    resources :chat_logs, path: 'chat'

    scope module: :public do
      resources :homes, path: '', only: [:index] do
        get 'calendar', to: 'homes#calendar', on: :collection, as: :calendar
        get 'join_calendar_info', to: 'homes#join_calendar_info', on: :collection, as: :join_calendar_info
        post 'join_calendar', to: 'homes#join_calendar', on: :collection, as: :join_calendar
      end
    end

    namespace 'company', path: 'setting' do
      resource :setting, only: [:show, :edit, :update] do
        get 'edit_notify_setting', to: 'settings#edit_notify_setting'
        put 'update_notify_setting', to: 'settings#update_notify_setting'
        get 'edit_calnedar_setting', to: 'settings#edit_calendar_setting'
        post 'save_calendar_setting', to: 'settings#save_calendar_setting'
      end
      resources :items
      resources :bulk_line_messages
      resources :calendars, only: [:index] do
        post 'save', to: 'calendars#save', on: :collection
      end
      resources :staffs
      resources :line_richmenu_images
      resources :sms_logs, path: 'sms'
    end

    scope module: :auth do
      devise_scope :user do
        get 'line_in/:line_user_id', to: 'sessions#line_in', as: :line_in
      end
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
