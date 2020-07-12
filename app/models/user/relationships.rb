module User::Relationships
  extend ActiveSupport::Concern

  def following
    User.find(Relationship.where(user_id: self.id).map{|f|f.follow_user_id})
  end

  
  def followers
    User.find(Relationship.where(follow_user_id: self.id, approved: true).map{|f|f.follow_user_id})
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


  
  
end