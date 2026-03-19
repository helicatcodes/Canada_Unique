Rails.application.routes.draw do
  # routes for the chatbot Chats & Messages controllers. NVD
  resources :chats, only: [:create, :show] do
    resources :messages, only: [:create]
  end

  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Routes for admin broadcast and user inbox. MJR
  resources :notifications, only: %i[index show new create]

  # Profile page route. MJR
  get "profile", to: "pages#profile", as: :profile
  get "pre_canada", to: "pages#pre_canada", as: :pre_canada
  get "in_canada", to: "pages#in_canada", as: :in_canada
  get "post_canada", to: "pages#post_canada", as: :post_canada
end
