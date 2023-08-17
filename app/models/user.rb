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

  private
  def broadcast_and_notify
    broadcast_append_to "users"
    notify_members
  end

  def notify_members
  end
end
