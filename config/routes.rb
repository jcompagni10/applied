Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'static_page#root'
  post '/send_mail', to: 'static_page#send_mail', as: "send_mail"
  resources :wappalyzer, only: [:index]
end
