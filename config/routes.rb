# frozen_string_literal: true

Rails.application.routes.draw do

  root to: 'home#index'
  
  # devise_for :users
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :workouts,    only: %i[index edit create stop resume destroy] do
    collection do
      get '/',            to: 'workouts#index'
      get 'start',        to: 'workouts#start'
      get 'stop',         to: 'workouts#stop'
      get 'resume',       to: 'workouts#resume'
    end
  end
  
  resources :setts,         only: %i[update]
  resources :routines,      only: %i[index]
  resources :exercises,     only: %i[index]
  resources :templates,     only: %i[index]
  resources :charts,        only: %i[index]
  resources :settings,      only: %i[index update]
  resources :achievements,  only: %i[index]
  resources :settings,      only: %i[index]
  resources :timeline,      only: %i[index]
  resources :relationships, only: %i[create ]

  resources :relationships, only: %i[create] do
    collection do
      post 'unfollow',           to: 'relationships#unfollow'
      post 'approve',            to: 'relationships#approve'
      post 'reject',             to: 'relationships#reject'
      post 'cancel_request',     to: 'relationships#cancel_request'
      post 'remove_invitation',  to: 'relationships#remove_invitation'
    end
  end
  
  resources :api,           :defaults => {:format => :json} do
    collection do
      get 'charts',         to: 'api#charts'
      get 'workouts',       to: 'api#workouts'
    end
  end


  resources :tutorials,      only: %i[index]
  get "/tutorials/:exercise/:page",   to: "tutorials#show"



  
  get '/billing' => 'billing#index', as: :billing
  get '/card/new' => 'billing#new_card', as: :add_payment_method
  get '/success' => 'billing#success', as: :success
  post '/card' => 'billing#create_card', as: :create_payment_method  
  
    
end
