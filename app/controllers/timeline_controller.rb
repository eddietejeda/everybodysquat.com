# frozen_string_literal: true

class TimelineController < ApplicationController


  def index

    
    
    
  end
  
  
  
  private

    # Only allow a trusted parameter "white list" through.
    def timeline_params
      params.permit(:exercise, :page)
    end
  
end
