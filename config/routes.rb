require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ['admin', ENV['RAILS_ADMIN_PASSWORD']]
end

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'

  devise_for(
    :owners, path: '',
     path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' },
     controllers: { sessions: 'devise_overwrites/sessions',
                    registrations: 'devise_overwrites/registrations',
                    confirmations: 'devise_overwrites/confirmations' }
  )

  resources :tickets, only: %i[create update]
  get 'risk-feed', to: 'tickets#risk_feed'

  post 'stripe-webhooks', controller: :stripe_webhooks, action: :create

  namespace :owners, path: '' do
    resources :companies, only: %i[index create update show] do
      resources :areas, only: %i[index create update show], shallow: true
      resources :tickets, only: :index
      resources :data_requests, only: %i[show index create], shallow: true
      get :stats
    end
    resource :owner, only: %i[show update]
    post :checkout, only: :create, controller: :checkouts, action: :create
    post :setup_intent, only: :setup_intent, controller: :checkouts
    post 'subscription-settings', only: :create, controller: :subscription_settings, action: :create
    post 'request-password-reset', controller: :password_resets, action: :request_reset
    post 'reset-password', controller: :password_resets, action: :reset
  end
end
