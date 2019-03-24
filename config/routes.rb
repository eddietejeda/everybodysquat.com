# frozen_string_literal: true

Rails.application.routes.draw do

  root to: 'home#index'
  
  devise_for :users
  
  resources :workouts,    only: %i[index edit create stop resume destroy] do
    collection do
      get 'create',       to: 'workouts#create'
      get 'stop',         to: 'workouts#stop'
      get 'resume',       to: 'workouts#resume'
    end
  end
  
  resources :setts,       only: %i[update]
  resources :routines,    only: %i[index]
  resources :exercises,   only: %i[index]
  resources :templates,   only: %i[index]
  resources :charts,      only: %i[index]
  resources :settings,    only: %i[index]

  resources :api,         :defaults => {:format => :json} do
    collection do
      get 'charts',       to: 'api#charts'
    end
  end

  get "/tutorials/:exercise/:page",   to: "tutorials#index"

  
end
