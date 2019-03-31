# frozen_string_literal: true

class HomeController < ApplicationController

  skip_before_action :authenticate_user!, :only => [:index]

  def index
    if current_user
      @personal_records     = current_user.personal_records
      @personal_achivements = current_user.personal_achivements
    else
      render "home/splash.haml", layout: "application"
    end


    
  end
  
  #
  # def achivements
  #
  #
  #
  # end
  #
  # def tutorials
  #
  #   if Dir.glob("#{Rails.root}/app/views/tutorials/**/**").map{|e|       e.split('tutorials/').last}.include?("#{home_params[:exercise]}/#{home_params[:page]}")
  #     render file: "tutorials/#{home_params[:exercise]}/#{home_params[:page]}"
  #   else
  #     render :status => 404
  #   end
  #
  # end
  #
  #
  

  private

    # Only allow a trusted parameter "white list" through.
    def home_params
      params.permit(:exercise, :page)
    end
  
end
