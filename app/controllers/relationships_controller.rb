# frozen_string_literal: true

class RelationshipsController < ApplicationController

    
  def create
    status = {}
    if u = User.where("email = :email", {email: relationship_params[:email]} ).first
      # success
      Rails.logger.info { "Relationship pending #{u.id} "}
      id = current_user.follow_request(u.id)
      
      status = {exists: true, id: u.id, username: u.username, id: id}
    else
      # failure
      Rails.logger.info { "Inviting new user"}
      id = current_user.invite(relationship_params[:email])
      status = {exists: false, email: relationship_params[:email], id: id}
    end
    
    render :json => status
  end
  
  
  def pending

  end
  

  def approve
    Rails.logger.info { "approved "}
    status = Relationship.where( "user_id = :user_id AND follow_user_id = :follow_user_id", { user_id: relationship_params[:follow_user_id], follow_user_id: current_user.id } ).first.update_attributes(approved: true)

    render :json => {status: status}
  
  end

  def reject
    Rails.logger.info { "reject "}
    status = Relationship.where( "user_id = :user_id AND follow_user_id = :follow_user_id", { user_id: relationship_params[:follow_user_id], follow_user_id: current_user.id } ).delete_all    
    render :json => {status: status}
  
  end


  def unfollow
    status = current_user.relationships.where("follow_user_id = :follow_user_id", { follow_user_id: relationship_params[:follow_user_id]}).delete_all
    render :json => status
  end

  # def cancel_request
  #   status = current_user.relationships.where("approved = false AND id = :id", {id: params[:id]}).delete_all
  #   render :json => status
  # end
  #

  def remove_invitation
    status = current_user.invitations.where("id = :invitation_id", { invitation_id: relationship_params[:invitation_id]}).delete_all
    render :json => status
  end
  
  
  
  private

    # Only allow a trusted parameter "white list" through.
    def relationship_params
      params.permit(:email, :invitation_id, :follow_user_id)
    end
  
  
end
