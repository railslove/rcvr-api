Rails.application.routes.draw do
  resources :tickets
  resources :companies

  get :'risk-feed', to: 'tickets#risk_feed'
end
