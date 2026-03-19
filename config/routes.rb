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
  resources :photos, only: [:create, :edit, :update, :destroy] do
    member do
      patch :toggle_share
    end
    # [HW] comments and likes are nested under photos because they belong to a specific photo
    # [HW] likes only needs :create because the create action toggles (like or unlike)
    resources :comments, only: [:create, :destroy]
    resources :likes,    only: [:create]
  end
  # [HW] FYI: member do adds a custom route that operates on a specific, existing record (it includes the :id in the URL).
  #       So patch :toggle_share inside it generates: PATCH /photos/:id/toggle_share → photos#toggle_share
  #       This is the right fit here because we're toggling the shared flag on a specific photo by its ID.

  # Profile page route. MJR
  get "profile", to: "pages#profile", as: :profile
  get "pre_canada", to: "pages#pre_canada", as: :pre_canada
  get "in_canada", to: "pages#in_canada", as: :in_canada
  get "post_canada", to: "pages#post_canada", as: :post_canada
end
