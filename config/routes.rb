Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'relationships#index'

  resources :videos, only: [:show] do
    collection do
      post :search, to: 'videos#search'
    end

  resources :reviews, only: [:create]
  end

  namespace :admin do
    get 'add_video', to: 'videos#new'
    resources :videos, only: [:create]
    get 'view_payments', to: 'payments#index'
    mount StripeEvent::Engine => 'payments#create'
  end

  resources :relationships, only: [:create, :destroy]
  resources :categories, only: [:show] 
  resources :users, only: [:create, :show]
  get 'register/:token', to: 'users#new_with_token', as: 'register_with_token'
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]

  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'

  get 'invite', to: 'invites#new'
  resources :invites, only: [:create]
end

