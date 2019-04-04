# frozen_string_literal: true

class UsersController < ApplicationController
  # helper_method :filtering_params
  # validate :reserved_username

  def index
    redirect_to root_path
  end

  def add_routine_to_user
    current_user.update!(routine_to_user_params)
    redirect_to "/routines"    
  end
  
  

  private

    def reserved_username
      reserved_usernames = %w[index show create destroy edit update signup interests interest item items search offers offer community about terms privacy admin map authentication]
      errors.add(:reserved_username, "username is reserved for the app") if reserved_usernames.include?(username)
    end
      
      
    def routine_to_user_params
      params.permit(:routine_id)
    end
    

end