require 'digest'


class SettingsController < ApplicationController

  def index
    @user = current_user
    @user_email_hash = Digest::MD5.hexdigest(current_user.email)
    unless current_user
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
  end
  
  def update
    # byebug
    current_user.update!(user_detail_params)    
  end
  
  def premium_subcription

  end
  

  private
    

  def user_detail_params
    
    params.require(:user).permit(:email, 
      details:[
        :equipment_type, 
        :equipment_plates, 
        :equipment_bar, 
        :body_weight
      ])
  end



end
