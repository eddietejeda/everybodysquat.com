# frozen_string_literal: true
require 'digest'


class ProfilesController < ApplicationController
  # helper_method :filtering_params
  # validate :reserved_username


  def settings
    @user = User.where("username = '#{params[:username]}'").first
    
    @user_email_hash = Digest::MD5.hexdigest(@user.email)
    
    unless @user
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
    @workouts = current_user.workouts.order(id: :desc)
  end

      


end
