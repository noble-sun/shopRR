Rails.application.routes.draw do
  resources :orders, only: [ :new, :create, :index ]
  resources :addresses
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token

  resources :products, only: [ :index ]
  get "products/:id", to: "products#show", as: "product", constraints: { id: /\d/ }
  namespace :seller do
    resources :products
  end

  resources :registrations, only: [ :new, :create ]
  resources :carts, only: [ :show ] do
    post "remove"
  end
  post "carts/add", to: "carts#add", as: "cart_add"

  namespace :auth do
    scope "/google" do
      get "authenticate", to: "google#authenticate", as: "google"
      get "callback", to: "google#callback", as: "google_callback"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "products#index"
end
