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
  
  resources :routines, only: %i[index new edit update create show], path: '/routines'
  resources :exercises, only: %i[index new edit update create show], path: '/exercises'
  resources :exercise_routines, only: %i[index new edit update create show], path: '/routines/:routine_id/exercises'

  # No social features yet
  # get "/:username/timeline", to: "users#timeline"
  # get "/:username/account", to: "users#account"
  # get "/:username/charts", to: "users#charts"
  # get "/:username/metrics", to: "users#metrics"


  get "/:username",           to: "profiles#show"
  get "/:username/timeline",  to: "profiles#timeline"
  get "/:username/account",   to: "profiles#account"
  get "/:username/charts",    to: "profiles#charts"
  get "/:username/goals",     to: "profiles#goals"
  


  get "users/:id/routines/:routine_id", to: "users#add_routine_to_user"

  
  resources :setts, only: %i[update], path: '/setts'
  
  
  devise_for :users
  
end
