#------------------------------------------------------------------------------
# User
#
# Name                   SQL Type             Null    Primary Default
# ---------------------- -------------------- ------- ------- ----------
# id                     bigint               false   true              
# name                   character varying    true    false             
# website                character varying    true    false             
# instagram              character varying    true    false             
# facebook               character varying    true    false             
# twitter                character varying    true    false             
# photo                  character varying    true    false             
# about                  text                 true    false             
# routine_id             integer              true    false   0         
# coach_id               integer              true    false   0         
# is_coach               boolean              false   false   false     
# is_admin               boolean              false   false   false     
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
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_writer :login

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  has_many :workouts
  belongs_to :routine, required: false
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validate :validate_username
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  
  after_create :send_admin_mail
  
  def active_workout
    self.workouts.where("active = true").first
  end
  
  def has_active_workout?
    active_workout ? true : false
  end

  def most_recent_workout
    Workout.where(user_id: self.id).last
  end

  def previous_workout
    Workout.where(user_id: self.id).last(2).first
  end

  def previous_exercise_setts(exercise_id)
    Sett.where(workout_id: self.previous_workout.id, exercise_id: exercise_id).order(created_at: :desc)
  end

  def previous_workout_weight(exercise_id)
    self.previous_exercise_setts(exercise_id).max_by(&:weight).try(:weight).to_i || current_user.bar_weight
  end

  def next_weight(routine_id, exercise_id, exercise_group, set_number)
    previous_workout_weight(exercise_id) + Routine.find(routine_id).templates.where(exercise_id: exercise_id, exercise_group: exercise_group).first.incremention_scheme.fetch(set_number).to_i
  end
  
  def previous_workout_before(start_date)
    Workout.where("user_id = :user_id AND created_at < :created_at", { user_id: self.id, created_at: start_date } ).first
  end
  
  def bar_weight
    # this should be stored in a setting somewhere
    return 45
  end

  def create_workout
    # get all possible exercise groups    
    all_exercise_groups = self.routine.exercise_groups 
    
    #if nothing, it's 0
    previous_workout_group = self.most_recent_workout.try(:exercise_group)

    # byebug

    # default to zero, but lets look inside. 
    current_group_pos = 0
    if !previous_workout_group.blank?
      # find the previous workout in the list
      previous_workout_pos = all_exercise_groups.index(previous_workout_group)

      # find the previous workout in the list, if it's the last item on the list, start back at 0
      current_group_pos = (previous_workout_pos == all_exercise_groups.length - 1) ? 0 : previous_workout_pos + 1
    end  
    
    exercise_group = all_exercise_groups.fetch(current_group_pos)
    workout = Workout.create({
      user_id: self.id,
      routine_id: self.routine_id,
      active: true,
      exercise_group: exercise_group
    })

    setts = []
    # We copy the template to a Sett
    Template.where("routine_id = :routine_id AND exercise_group = :exercise_group", 
      { routine_id: self.routine_id, exercise_group: exercise_group } ).each do |template|
      
      template.sets.times do |set_number|

        setts << {
          workout_id: workout.id,
          exercise_id: template.exercise_id,
          weight: self.next_weight(template.routine_id, template.exercise_id, template.exercise_group, set_number),
          set_goal: template.sets,
          reps_goal: template.reps,
          set_completed: 0,
          reps_completed: 0,
        }
      end
      
    end
    
    
    Sett.create(setts)
    
    return workout
  end

  
  
  def set_default_routine
    r = self.routine_id
    r.routine_id = Routine.first.id
    r.update!
  end
  
  def is_coach?
    self.is_coach
  end
  
  def is_trainee?
    !self.is_coach
  end
  
  def is_admin?
    self.is_admin
  end
  
  def trainees
    if self.is_coach?
      User.where(coach_id: self.id)
    else
      logger.info "User is not a coach"
      User.none
    end
  end
  
  
  
  
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end


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

  def login
    @login || self.username || self.email
  end
  
  def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    approved? ? super : :not_approved
  end
  
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end
  
end

