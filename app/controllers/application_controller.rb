# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Turbolinks::Redirection

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_browser_type
  before_action :authenticate_user!
  
  private

    def set_browser_type
      @device_type = request.headers["HTTP_USER_AGENT"].match("EveryBody iOS") ? "ios-app" : "web-app"
    end

  protected

    def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
  
end
