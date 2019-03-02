# frozen_string_literal: true

class UsersController < ApplicationController
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

  def metrics
    
  end
  
  def charts
    
  end

  def timeline
    
  end


  private

    def reserved_username
      reserved_usernames = %w[index show create destroy edit update signup interests interest item items search offers offer community about terms privacy admin map authentication]
      errors.add(:reserved_username, "username is reserved for the app") if reserved_usernames.include?(username)
    end
      


end