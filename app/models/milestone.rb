class Milestone < ApplicationRecord
  belongs_to :project
  has_many   :tasks

  validates :name,        presence: true, length: {minimum:  4, maximum:  40}
  validates :description, presence: true, length: {minimum: 10, maximum: 200}
  # validates :completion, size: {maximum: 100}
 
  def update_completion
    done  = 0
    self.tasks.each {|task| done += 100 if task.complete == true }
    self.completion = done.to_f/tasks.count
  end
end 
