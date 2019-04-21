# frozen_string_literal: true

class TimelineController < ApplicationController


  def index
    @following = current_user.following
    @followers = current_user.followers
    
    @requests = current_user.follow_requests
    # @pending_followers = current_user.pending_followers
    # @follow_pending = current_user.follow_pending

    @invitations = current_user.invitations
    
    @workouts = current_user.all_following_user_workouts
  end
  
    #
  #
  # def pending
  #
  # end
  #
  #
  #
  # def approve
  #   if f = Following.where( "id = :id AND user_id = :user_id", {id: params[:id], user_id: current_user.id } ).first
  #     # success
  #
  #     Rails.logger.info { "approved #{f.id} "}
  #     f.approved = true
  #     status = f.save!
  #   else
  #     # failure
  #     Rails.logger.info { "TODO: send invite "}
  #     # current_user.send_invitation()
  #     status = false
  #   end
  #
  #
  #   render :json => {status: status}
  #
  # end
  #
  # def create
  #
  #   if u = User.where("email = :email", {email: follow_request_params[:email]} ).first
  #     # success
  #     Rails.logger.info { "Following pending #{u.id} "}
  #     current_user.follow_request(u.id)
  #   else
  #     # failure
  #     Rails.logger.info { "TODO: send invite "}
  #     # current_user.send_invitation()
  #   end
  #
  # end
  #
  #
  # private
  #
  #   # Only allow a trusted parameter "white list" through.
  #   def follow_request_params
  #     params.permit(:email)
  #   end
  #
end
