Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :events, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    member do
      get :duplicate
      post :create_from_event
    end
    resources :bookings, only: [:create]

  end

  resources :users, only: [:show, :edit, :update]

  resources :bookings, only: [:index, :destroy] do
    resources :payments, only: [:new]
  end

  resources :posts, only: [:new, :create, :index, :show] do
    resources :comments, only: :create
  end

  get "/dashboard", to: "users#dashboard", as: :dashboard

  get "/search", to: "events#search", as: :search
  get "/events/:event_id/fake", to: "payments#fake", as: :fake

  mount StripeEvent::Engine, at: '/stripe-webhooks'

  # Defines the root path route ("/")
  # root "posts#index"
end
