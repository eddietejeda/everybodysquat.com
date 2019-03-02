# frozen_string_literal: true

Rails.application.routes.draw do
  # root to: 'workouts#index'
  
  get '/' => 'static#home'


  resources :workouts, only: %i[index create update destroy edit stop], path: '/workouts' do
    collection do
      get 'stop', to: 'workouts#stop'
      get 'create', to: 'workouts#create'
    end
  end
  
  resources :routines, only: %i[index create show], path: '/routines'

  get "/:username", to: "users#show"
  get "/:username/timeline", to: "users#timeline"
  get "/:username/account", to: "users#account"
  get "/:username/charts", to: "users#charts"
  get "/:username/metrics", to: "users#metrics"
  

  
  resources :setts, only: %i[update], path: '/setts'
  
  
  devise_for :users
  
end
