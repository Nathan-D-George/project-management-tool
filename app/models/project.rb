class Project < ApplicationRecord

  after_create_commit { broadcast_append_to "projects" }
  
  has_many_attached :attachments, dependent: :destroy

  has_many :milestones, dependent: :destroy

  def expenses
    expenses   = 0
    milestones = self.milestones
    milestones.each {|milestone|
      tasks = milestone.tasks
      tasks.each {|task|
        duration = 1
        day      = task.start_date
        (task.end_date - task.start_date).to_i.times do
          day      += 1.day
          duration += 1 if day.on_weekday?
        end
        hours_worked = duration * 8
        hourly_rate  = User.find(task.assigned_to).hourly_rate
        expenses    += hours_worked * hourly_rate
      }
    }
    self.expenses = expenses
  end

  def update_percent_complete
    sum = 0
    num = 0
    self.milestones.each {|milestone| 
      milestone.tasks.each{|task|
        sum += 100 if task.complete == true
        num += 1
      }
    }
    self.percent_complete = sum.to_f/num 
  end

  def members
    members = []
    User.all.each{|u|
      members.append(u) if Participant.where(user_id: u.id).all.where(project_id: self.id).present?
    }
    members
  end

  def non_members
    non_members = []
    User.all.each{|u|
      non_members.append(u) if Participant.where(user_id: u.id).all.where(project_id: self.id).blank?
    }
    non_members
  end

  def self.day_options
    days = []
    31.times do |d|
      days.append(d+1)
    end
    days.to_a
  end

  def self.month_options
    Date::MONTHNAMES.compact.each_with_index.map {|name, index| ["#{name}", index+1]}
  end

  def self.year_options
    (Date.today.year..(Date.today.year+10)).to_a
  end
  
end
