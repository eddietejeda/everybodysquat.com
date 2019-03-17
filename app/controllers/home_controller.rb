# frozen_string_literal: true

class HomeController < ApplicationController

  skip_before_action :authenticate_user!, :only => [:index]

  def index
    if current_user
      redirect_to "/#{current_user.username}/workouts"
    else
      render "home/index.haml", layout: "application"
    end
  end
  
  
  def tutorials
    
    
  end
  
  
  

  private

    # Only allow a trusted parameter "white list" through.
    def home_params
      params.permit(:exercise, :page)
    end
  
end
