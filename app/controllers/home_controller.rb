# frozen_string_literal: true

class HomeController < ApplicationController

  skip_before_action :authenticate_user!, :only => [:index]

  def index
    # if current_user
    #   redirect_to "/#{current_user.username}/workouts"
    # else
    #   render "home/index.haml", layout: "application"
    # end
    

    @achivements = ["Squatted your own body weight of 170lbs  "]
    
    exercise_list = current_user.routine.exercises.group(:id)

    @prs = []
    exercise_list.each do |e|
      @prs << current_user.highest_weight_sett(e.id)
    end
    
  end
  

  def achivements
    
    
    
  end
    
  def tutorials
    
    
  end
  
  
  

  private

    # Only allow a trusted parameter "white list" through.
    def home_params
      params.permit(:exercise, :page)
    end
  
end
