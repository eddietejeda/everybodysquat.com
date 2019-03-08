# frozen_string_literal: true

class ProfilesController < ApplicationController
  # helper_method :filtering_params
  # validate :reserved_username


  def show
    @user = User.where("username = '#{params[:username]}'").first
    
    unless @user
      # raise ActionController::RoutingError.new('Not Found')
      # render :status => 404
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
    
  end

  def goals
    
  end
  
  def charts
    
  end

  def timeline
    
  end

  def workouts
    @workouts = current_user.workouts
  end

      


end
