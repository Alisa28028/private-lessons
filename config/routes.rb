Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "locations/search", to: "locations#search"

  resources :events, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    member do
      get :duplicate
      post :add_video
    end
    resources :bookings, only: [:create]
    #  Nested posts for events, including edit and update
    resources :posts, only: [:new, :create, :edit, :update, :index, :show] do
      collection do
        get :create_from_event #Allows creating posts from events
      end
        resources :comments, only: :create
    end
    resources :videos, only: [:create, :destroy]
  end
  # Standalone video routes (for independent uploads)
  resources :videos, only: [:create, :index, :show, :destroy]
   # Routes for managing event instances independently
   resources :event_instances, only: [:show, :index, :edit, :update, :destroy] do
    resources :bookings, only: [:create]
   end
   # Non-nested posts resource for standalone posts
   resources :posts, only: [:new, :create, :index, :show, :destroy] do
    collection do
      post :save
    end
  end
    # User routes (show, edit, update)
  resources :users, only: [:show, :edit, :update] do
    member do
      get :classes
      get :teacher_posts
      get :student_posts
    end
  end

   # locations routes
   resources :locations

  #  ---------for autocomplete------------
    # # locations routes
    # resources :locations do
    #   collection do
    #     get :autocomplete
    #   end
    # end

    # booking routes
    resources :bookings, only: [:index, :destroy] do
      resources :payments, only: [:new]
  end

  # Dashboard route for users
  get "/dashboard", to: "users#dashboard", as: :dashboard

  # Search route for events
  get "/search", to: "events#search", as: :search

  # Fake payment route
  get "/event_instances/:event_instance_id/fake", to: "payments#fake", as: :fake_event_instance

   # Mount StripeEvent engine for handling webhooks
  mount StripeEvent::Engine, at: '/stripe-webhooks'

  # Defines the root path route ("/")
  # root "posts#index"
end
