# frozen_string_literal: true

class SettsController < ApplicationController
  # helper_method :filtering_params


  
  def update
    Sett.where(id: params[:id], user_id: current_user.id).first.update!(sett_params)
  end
  
  
  private
  
  def sett_params
    params.permit(:id, :reps_completed, :weight)
  end
  
end

