# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  about                  :string
#  website                :string
#  instagram              :string
#  twitter                :string
#  facebook               :string
#  coach_id               :string
#  photo                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  workouts               :string
#  is_coach               :boolean
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  is_admin               :boolean          default(FALSE), not null
#  routine_id             :integer
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_writer :login

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  has_many :workouts
  # belongs_to :routine
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validate :validate_username
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  
  
  after_create :send_admin_mail
  
  
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end


  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
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

  def active_workout
    self.workouts.where("active = true").first
  end
  
  def has_active_workout?
    active_workout ? true : false
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

  def create_workout
    
    # previous = Workout.where(self.id).
    
    workout = Workout.create({
      user_id: self.id,
      routine_id: self.routine.id,
      active: true
    })

    setts = []

    self.routine.exercise_routines.each do |exercise|

      # Sett.where(exercise_id: 10).last.set_goal == Sett.where(exercise_id: 10).last.set_completed
      
      exercise.reps.times do 
        setts << {
          workout_id: workout.id,
          exercise_id: exercise.id,
          weight: workout.incremented_weight(exercise.id),
          set_goal: exercise.sets,
          reps_goal: exercise.reps,
          set_completed: 0,
          reps_completed: 0
        }
      end
    end
    
        
    Sett.create(setts)
    
    return workout
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
  
end
