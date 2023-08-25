class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
             uniqueness: {case_sensitive: false},
             length: {minimum:  4, maximum:  40},
             format: {with: VALID_EMAIL_REGEX}

  scope :all_except, -> (user) {where.not(id: user)} 
  
  after_create_commit { broadcast_append_to 'users' } # { broadcast_and_notify }

  enum role: %i[leader member unassigned]
  enum job:  %i[unemployed boss engineer architect admin_officer qa_officer it_guy janitor accountant]
  
  def set_hourly_rate
    self.hourly_rate =   0 if self.job == "unemployed"
    self.hourly_rate = 100 if self.job == "janitor"
    self.hourly_rate = 150 if self.job == "admin_officer"
    self.hourly_rate = 200 if self.job == "qa_officer" || self.job == "architect"
    self.hourly_rate = 250 if self.job == "accountant" || self.job == "it_guy"
    self.hourly_rate = 300 if self.job == "engineer"
    self.hourly_rate = 400 if self.job == "boss"
  end

  def self.job_options
    ar = ['boss', 'engineer', 'architect', 'admin_officer', 'qa_officer', 'it_guy', 'janitor', 'accountant']
  end

  private
  def broadcast_and_notify
    broadcast_append_to "users"
    notify_members
  end

  def notify_members
  end
end
