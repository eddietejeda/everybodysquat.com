require 'digest'


class SettingsController < ApplicationController

  def index
    
    @user_email_hash = Digest::MD5.hexdigest(current_user.email)
    
    unless current_user
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
    
  end


  private
    
  def profile_params
    params.permit(:page)    
  end

      


end
