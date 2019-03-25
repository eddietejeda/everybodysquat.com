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


  # most recent workout and previous might seem similar but it's important not to confuse them
  # most_recent_work gets the most recent workout, wether there is an active one or not
  def most_recent_workout
    Workout.where(user_id: self.id).last
  end

  # previous_workout is looking for the previous before the current one.
  def previous_workout
    Workout.where(user_id: self.id).last(2).first
  end
  
  def most_recent_workout_by_group(group_name)
    Workout.where(user_id: self.id, exercise_group: group_name).order(:id).last
  end

  # previous_workout_before the workout before the a specific date
  # TODO: is this performant? 
  def previous_workout_before(before_date)
    Workout.where("user_id = :user_id AND created_at < :created_at", { 
      user_id: self.id, created_at: before_date 
    }).first
  end

  def previous_workout_exercise_setts(exercise_id)
    previous_workout ? Sett.where(workout_id: previous_workout.id, exercise_id: exercise_id).order(created_at: :desc) : Sett.none
  end

  def weight_of_previous_workout_exercise(exercise_id)
    previous_workout.training_maxes.find{|e| 
      e["exercise_id"] == exercise_id  
    }.to_h["weight"] || 45
  end
  
  def should_increase_weight(exercise_id)
    successful_sets = previous_workout_exercise_setts(exercise_id).to_a.map{|e|
      (e.reps_completed == e.reps_goal) && (e.reps_completed > 0)
    }
    previous_workout_exercise_setts(exercise_id).exists? && successful_sets.all? {|a|a}
  end


  def weight_of_next_training_max(exercise_id, exercise_group)

    if should_increase_weight(exercise_id)
      current_exercise_training_max(exercise_id, exercise_group) + 5
    elsif should_decrease_weight(exercise_id)
      current_exercise_training_max(exercise_id, exercise_group) - 20
    else
      # stay the same
      current_exercise_training_max(exercise_id, exercise_group) || current_user.bar_weight
    end
  end
  
  
  def current_exercise_training_max(exercise_id, exercise_group)
    most_recent_workout_by_group(exercise_group).try(:training_maxes).to_a.find{|e|
      e.to_h["exercise_id"] == exercise_id
    }.to_h["weight"].to_i    
  end
  
  #TODO:
  def should_decrease_weight(exercise_id)
    false
  end
  
  def weight_for_next_set(exercise_id, exercise_group, set_number)
    previous = weight_of_previous_workout_exercise(exercise_id)
    should_increase_weight(exercise_id) ? current_user.routine.increment_weight(previous, exercise_id, exercise_group, set_number) : previous
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
  
  
  def highest_weight_sett(exercise_id)
    Sett.where(user_id: current_user.id, exercise_id: exercise_id).where("set_goal > 0").order(weight: :desc).limit(1).first || Sett.none
  end
  
  
  
  def bar_weight
    # this should be stored in a setting somewhere
    return 45
  end




  def next_exercise_group_name
    # get all possible exercise groups    
    all_exercise_groups = self.routine.exercise_groups 
    
    #we use try() just in case there is no previous workout
    previous_workout_group = self.most_recent_workout.try(:exercise_group)

    # default to zero, but lets look inside. 
    current_group_pos = 0
    if !previous_workout_group.blank?
      # find the previous workout in the list
      previous_workout_pos = all_exercise_groups.index(previous_workout_group)
      # find the previous workout in the list, if it's the last item on the list, start back at 0
      current_group_pos = (previous_workout_pos == all_exercise_groups.length - 1) ? 0 : previous_workout_pos + 1
    end  
    
    all_exercise_groups.fetch(current_group_pos)
  end
  
  def template_exercises_by_group(exercise_group)
    Template.where("routine_id = :routine_id AND exercise_group = :exercise_group", { 
      routine_id: self.routine_id, exercise_group: exercise_group 
    })
  end

  def adjust_training_maxes_by_group(exercise_group)   
    template_exercises_by_group(exercise_group).map{|e|
      {
        exercise_id: e.exercise_id, 
        weight: weight_of_next_training_max(e.exercise_id, exercise_group)
      }
    }
  end

  
  def create_workout
    CreateUserWorkout.new(current_user).call
  end

  def personal_records
    current_user.routine.distinct_exercises.map do |e|
      current_user.highest_weight_sett(e.id)
    end
  end

  def chart_user_workouts
    CreateUserWorkoutChart.new(current_user).call
  end
  
  def set_default_routine
    r = self.routine_id
    r.routine_id = Routine.first.id
    r.update!
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

