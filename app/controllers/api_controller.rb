# frozen_string_literal: true

# Place holder for JS calls
class ApiController < ApplicationController
  # helper_method :filtering_params

  
  def charts
    render :json => current_user.get_progress_charts.as_json, layout: false
  end    


  def workouts
    render :json => current_user.workouts.as_json, layout: false
  end    




end