class Milestone < ApplicationRecord
  belongs_to :project
  has_many   :tasks

  validates :name,        presence: true, length: {minimum:  4, maximum:  40}
  validates :description, presence: true, length: {minimum: 10, maximum: 200}
  # validates :completion, size: {maximum: 100}

  def expenses
    tasks = self.tasks
    costs = 0
    tasks.each {|task|
      user = User.find(task.assigned_to)
      rate = user.hourly_rate
      day  = task.start_date
      duration = 1
      (task.end_date - task.start_date).to_i.times do
        day      += 1.day
        duration += 1 if day.on_weekday?
      end
      hours  = duration * 8
      costs += rate * hours
    }
    return costs
  end

  def update_completion
    done  = 0
    self.tasks.each {|task| done += 100 if task.complete == true }
    self.completion = done.to_f/tasks.count
  end
end 
