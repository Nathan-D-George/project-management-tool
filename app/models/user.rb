class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
