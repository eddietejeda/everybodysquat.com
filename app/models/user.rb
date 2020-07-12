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
  include User::Admin, User::Coach, User::Notifications, User::Relationships, User::Settings, User::Trainee, User::Workouts
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # attr_writer :login
  # attr_accessor :sign_up_code
  # validates :sign_up_code, on: :create, presence: true, inclusion: { in: ["brooklyn"] }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
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
  
  
  # def validate_username
  #   if User.where(email: username).exists?
  #     errors.add(:username, :invalid)
  #   end
  # end

  def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    approved? ? super : :not_approved
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
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