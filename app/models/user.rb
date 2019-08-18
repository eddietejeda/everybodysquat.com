#------------------------------------------------------------------------------
# User
#
# Name                   SQL Type             Null    Primary Default
# ---------------------- -------------------- ------- ------- ----------
# id                     bigint               false   true              
# name                   character varying    true    false             
# about                  text                 true    false             
# routine_id             integer              true    false   0         
# coach_id               integer              true    false   0         
# coach                  boolean              false   false   false     
# admin                  boolean              false   false   false     
# bar_weight             integer              true    false   0         
# email                  character varying    false   false             
# encrypted_password     character varying    false   false             
# reset_password_token   character varying    true    false             
# reset_password_sent_at timestamp without time zone true    false             
# remember_created_at    timestamp without time zone true    false             
# sign_in_count          integer              false   false   0         
# current_sign_in_at     timestamp without time zone true    false             
# last_sign_in_at        timestamp without time zone true    false             
# current_sign_in_ip     inet                 true    false             
# last_sign_in_ip        inet                 true    false             
# confirmation_token     character varying    true    false             
# confirmed_at           timestamp without time zone true    false             
# confirmation_sent_at   timestamp without time zone true    false             
# unconfirmed_email      character varying    true    false             
# failed_attempts        integer              false   false   0         
# unlock_token           character varying    true    false             
# locked_at              timestamp without time zone true    false             
# created_at             timestamp without time zone false   false             
# updated_at             timestamp without time zone false   false             
# username               character varying    true    false             
# approved               boolean              false   false   false     
#
#------------------------------------------------------------------------------

class User < ApplicationRecord

  include Stripe::Callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # attr_writer :login
  attr_accessor :sign_up_code 
  validates :sign_up_code, on: :create, presence: true, inclusion: { in: ["brooklyn"] }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  #, authentication_keys: [:login]

  has_many :workouts
  has_many :invitations

  belongs_to :routine, required: false

  has_many :relationships

  # validates :username, presence: :true, uniqueness: { case_sensitive: false }
  # validate :validate_username
  # validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  after_create :set_default_user_settings
  
  after_create :send_admin_mail
  
  
  after_customer_updated! do |customer, event|
    user = User.find_by_stripe_customer_id(customer.id)
    if customer.delinquent
      user.is_account_current = false
      user.save!
    end
  end
  
  
  
  def active_workout
    self.workouts.where("active = true").first
  end
  
  def has_active_workout?
    active_workout ? true : false
  end


  def set_default_user_settings
    self.routine = Routine.first
    self.details = {"body_weight"=>"", "equipment_bar"=>"45", "equipment_type"=>"barbell", "equipment_plates"=>"45"}
    self.save!
  end


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
  
  # most recent workout and previous might seem similar but it's important not to confuse them
  # most_recent_work gets the most recent workout, wether there is an active one or not
  def most_recent_workout
    Workout.where(user_id: self.id).last
  end

  # previous_workout is looking for the previous before the current one.
  def previous_workout
    Workout.where(user_id: self.id).last(2).first
  end
  

  def complete_workout(workout)
    CompleteUserWorkout.new(self).call(workout)
  end
  
  def create_workout
    CreateUserWorkout.new(self).call
  end

  def chart_user_workouts
    CreateUserWorkoutChart.new(self).call
  end
  
  
  def bar_weight
    # this should be stored in a setting somewhere
    return 45
  end
  
  def settings(keyname)
    
    default = {}
    default["rest_time"] = (60*3) # minutes
    default["bar_weight"] = 45
    
    return self.details.to_h[keyname] if self.details.to_h[keyname]
    return default.to_h[keyname] if default.to_h[keyname]
    return nil
  end
  
  
  
  def generate_milestones
    
    timeline = {}
    
  end

  # TODO: stale?
  def workout_exercise_was_succcessful(workout_id, exercise_id)
    successful_sets = Workout.find(workout_id).setts.where(exercise_id: exercise_id).map{|e|
      (e.reps_completed == e.reps_goal) && (e.reps_completed > 0)
    }
    self.where(exercise_id: exercise_id).exists? && successful_sets.all? {|a|a}
  end
  
  
  def next_workout_date
    # this is not pretty, but I needed to get this out quickly to test other things
    # TODO: rewrite to take multiple algorithms for different programs. this is currently 5x5
    # Routine.find(self.routine_id).templates.where(exercise_id: exercise_id, exercise_group: exercise_group).first.incremention_scheme.fetch(set_number).to_i
    week_array = [false,true,false,true,false,true,false] # this is basically 5x5/M-W-F
    wday = Time.now.wday

    week_array.each_with_index do |value, key|
      wnext = (wday + key)%week_array.count
      if week_array.fetch(wnext)
        return Time.now + key.days
      end
    end
    
    # We should never be here.
    Rails.logger.error {"User.next_workout_date not finding the next workout date and defaulting to tomorrow"}
    Time.now + 1.days
  end


  def personal_records
    
    response = []
    if self.routine
      response = self.routine.distinct_exercises.map {|exercise|
        self.highest_weight_sett(exercise.id).try("id")
      }
    end
    
    response.any? ? Sett.find(response) : []
    
  end


  def personal_achivements
    []
  end



  def highest_weight_sett(exercise_id)
    Sett.where(user_id: self.id, exercise_id: exercise_id).where("reps_completed > 0").order(weight: :desc).limit(1).first || Sett.none
  end


  
  def is_coach?
    self.coach
  end
  
  def is_trainee?
    !self.coach
  end
  
  def is_admin?
    self.admin
  end
  

  # def validate_username
  #   if User.where(email: username).exists?
  #     errors.add(:username, :invalid)
  #   end
  # end

  def send_admin_mail
    UserMailer.new_user_waiting_for_approval(email).deliver
  end
  
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end
  #
  # def login
  #   @login || self.username || self.email
  # end
  #
  def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    approved? ? super : :not_approved
  end
  
  #
  # def self.find_first_by_auth_conditions(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login)
  #     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #   else
  #     if conditions[:username].nil?
  #       where(conditions).first
  #     else
  #       where(username: conditions[:username]).first
  #     end
  #   end
  # end
  
end