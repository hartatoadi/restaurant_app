Rails.application.routes.draw do
  #devise_for :users
  #devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "rails/welcome#index"

  resources :customers, only: [] do
    post :import_csv, on: :collection
  end
  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'password123'
  end

  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'verify_mfa', to: 'users#verify_mfa'
  post 'verify_mfa', to: 'users#verify_mfa_submit'
end
