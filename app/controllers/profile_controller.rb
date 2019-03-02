# frozen_string_literal: true

class ProfileController < ApplicationController
  # helper_method :filtering_params

  def show
    
    @user = User.where("username = '#{params[:username]}'")
    
    if @user.empty?
      raise ActionController::RoutingError.new('Not Found')
    end
    
    
    
  end



end