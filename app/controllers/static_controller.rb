# frozen_string_literal: true

class StaticController < ApplicationController

  skip_before_action :authenticate_user!, :only => [:home]

  def home
    if current_user
      redirect_to :controller => 'workouts'
    else
      render "static/index.haml", layout: "application"
    end
  end
  
end
