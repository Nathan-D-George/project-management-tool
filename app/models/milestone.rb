class Milestone < ApplicationRecord
  belongs_to :project
  has_many   :tasks

  validates :name,        presence: true, length: {minimum:  4, maximum:  40}
  validates :description, presence: true, length: {minimum: 10, maximum: 200}
  
end
