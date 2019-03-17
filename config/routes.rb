# frozen_string_literal: true

Rails.application.routes.draw do

  root to: 'home#index'
  
  devise_for :users
  
  
  resources :routines,    only: %i[index new edit update create show], path: '/routines'
  resources :exercises,   only: %i[index new edit update create show], path: '/exercises'
  resources :templates,   only: %i[index new edit update create show], path: '/templates'
  resources :setts,       only: %i[update], path: '/setts'

  resources :workouts, only: %i[index new create update destroy edit stop], path: '/workouts' do
    collection do
      get 'stop', to: 'workouts#stop'
      get 'create', to: 'workouts#create'
      get 'resume', to: 'workouts#resume'
    end
  end
  
  get "/:username/workouts",  to: "profiles#workouts"
  get "/:username/timeline",  to: "profiles#timeline"
  get "/:username/account",   to: "profiles#account"
  get "/:username/settings",  to: "profiles#settings"
  get "/:username/charts",    to: "profiles#charts"
  get "/:username/goals",     to: "profiles#goals"
  get "/users/:id/routines/:routine_id", to: "users#add_routine_to_user"


  get "/tutorials/:exercise/:page",   to: "home#tutorials"
  get "/:username",                   to: "home#index"

  # scope :admin do
  #   resources :workouts
  #   resources :routines
  #   resources :templates
  #   resources :setts
  # end
  
end
