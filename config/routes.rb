Rails.application.routes.draw do
  devise_for :owners,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' },
             controllers: { sessions: 'sessions', registrations: 'registrations' }

  resources :tickets
  resources :companies
  resource :owner, only: :update

  get 'risk-feed', to: 'tickets#risk_feed'
end
