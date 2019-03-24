# frozen_string_literal: true

class TutorialsController < ApplicationController


  def index
    
    if Dir.glob("#{Rails.root}/app/views/tutorials/**/**").map{|e|       e.split('tutorials/').last}.include?("#{home_params[:exercise]}/#{tutorials_params[:page]}")
      render file: "tutorials/#{home_params[:exercise]}/#{home_params[:page]}"
    else
      render :status => 404
    end
    
  end
  
  
  private

    # Only allow a trusted parameter "white list" through.
    def tutorials_params
      params.permit(:exercise, :page)
    end
  
end
