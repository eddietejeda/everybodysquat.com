# frozen_string_literal: true

class AchievementsController < ApplicationController


  def index
    @personal_records = current_user.personal_records
  end
  
  
  private

    # Only allow a trusted parameter "white list" through.
    def achievements_params
      params.permit(:exercise, :page)
    end
  
end
