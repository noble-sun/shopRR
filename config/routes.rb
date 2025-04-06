Rails.application.routes.draw do
  scope "(:locale)", locale: /pt-BR|en/ do
    resources :orders, only: [ :new, :create, :index ]
    resources :addresses
    resource :session, only: [ :new, :create, :destroy ]
    resources :passwords, param: :token

    resources :products, only: [ :index ] do
      resources :product_reviews, only: [ :new, :create, :show, :edit, :update ]
    end
    get "reviews", to: "product_reviews#reviews"
    get "products/:id", to: "products#show", as: "product", constraints: { id: /\d+/ }

    namespace :seller do
      post "enable", to: "sellers#enable", as: "enable"
      resources :products
    end

    resources :registrations, only: [ :new, :create ]
    resources :carts, only: [ :show ] do
      post "remove"
      patch "update_item_quantity"
    end
    post "carts/add", to: "carts#add", as: "cart_add"

    namespace :auth do
      scope "/google" do
        get "authenticate", to: "google#authenticate", as: "google"
        get "callback", to: "google#callback", as: "google_callback"
      end
    end

    # Defines the root path route ("/")
    root "products#index"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "/", to: redirect { |params, req|
    locale = req.session[:locale] || I18n.default_locale
    "/#{locale}"
  }
end
