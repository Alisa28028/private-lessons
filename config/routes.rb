Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
  get 'favorites/index'


  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: { registrations: "users/registrations" }

  get "about_us", to: "pages#about_us", as: :about_us
  get "contact", to: "pages#contact", as: :contact
  get "what_is", to: "pages#what_is", as: :what_is

  get '/dashboard', to: 'dashboards#show', as: :dashboard
  get '/select_dashboard_preference', to: 'dashboards#select_preference'
  patch '/update_dashboard_preference', to: 'dashboards#update_dashboard_preference'
  get '/student_dashboard', to: 'dashboards#student', as: :student_dashboard
  get '/teacher_dashboard', to: 'dashboards#teacher', as: :teacher_dashboard

  get "locations/search", to: "locations#search"

  resources :favorites, only: [:index]

  resources :events, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    member do
      get :duplicate
      post :add_video
    end

    resources :bookings, only: [:create, :index]
    #  Nested posts for events, including edit and update
    resources :posts, only: [:new, :create, :edit, :update, :index, :show] do
      collection do
        get :new_from_event_instance
        post :create_from_event_instance
      end
        resources :comments, only: :create
    end
    resources :videos, only: [:create, :destroy]
  end

  resources :event_instances, only: [:show] do
    resource :like, only: [:create, :destroy], controller: 'likes'
    resources :posts, only: [:new, :create]
  end

  resources :weekly_availabilities do
    get :new_fields, on: :collection
  end


  # Standalone video routes (for independent uploads)
  resources :videos, only: [:create, :index, :show, :destroy]
   # Routes for managing event instances independently
   resources :event_instances, only: [:show, :index, :edit, :update, :destroy] do
    resources :bookings, only: [:create]
    resources :posts, only: [:new, :create, :edit, :update, :destroy, :show] do
      member do
        get :cancel_edit
        post :hide
      end
    end
   end
   # Non-nested posts resource for standalone posts
   resources :posts, only: [:new, :create, :edit, :update, :index, :show, :destroy] do
    collection do
      post :save
    end
    member do
      get :cancel_edit
      post :hide
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
      member do
          patch :update_payment_state
          patch :update_status
          post :approve
          post :cancel
      end
  end

  # # Dashboard route for users
  # get "/dashboard", to: "users#dashboard", as: :dashboard

  # Search route for events
  get "/search", to: "events#search", as: :search

  # Fake payment route
  get "/event_instances/:event_instance_id/fake", to: "payments#fake", as: :fake_event_instance

   # Mount StripeEvent engine for handling webhooks
  mount StripeEvent::Engine, at: '/stripe-webhooks'

  # Defines the root path route ("/")
  # root "posts#index"
end
end
