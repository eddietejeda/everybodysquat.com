class Relationship < ApplicationRecord
  belongs_to :user
  
  
  

  def follow_request(follow_user_id)
    # TODO: Rails 6 note: https://sikac.hu/use-create-or-find-by-to-avoid-race-condition-in-rails-6-0-f44fca97d16b
    f = Relationship.find_or_create_by(user_id: self.id, follow_user_id: follow_user_id)
    
    f.nonce = SecureRandom.hex(32)
    f.save!
  end

  
  def follow_requests
    User.find(Relationship.where("follow_user_id = :follow_user_id AND approved = :approved", { follow_user_id: self.id, approved: false }).map{|u|u.user_id} ) 
    
  end
  


  def invite(email)
    Invitation.find_or_create_by(user_id: self.id, email: email)
    # UserMailer.send_invitation()
  end
  

  def follow_pending
    User.find( Relationship.where(user_id: self.id, approved: false).map{|f|f.follow_user_id} ) 
  end
  
  


  # def approved_following
  #   User.find(Relationship.where(user_id: self.id, approved: true).map{|f|f.friend_id})
  # end
  

  def all_following_user_workouts
    Workout.where("user_id IN (:user_ids)", {user_ids: self.following }).order(began_at: :asc).limit(10)
  end
  
  def following_user?(user_id)
    self.following.find{|u|u.id == user_id && u.approved == true}.class == User
  end

  def follow_pending?(user_id)
    self.follow_pending.find{|u|u.id == user_id}.class == User
  end

  def invitation_pending?(email)
    self.invitations.where("email = :email", {email: email}).count == 1
  end

  def following
    User.find(Relationship.where(user_id: self.id).map{|f|f.follow_user_id})
  end

  
  def followers
    User.find(Relationship.where(follow_user_id: self.id, approved: true).map{|f|f.follow_user_id})
  end
  

end
