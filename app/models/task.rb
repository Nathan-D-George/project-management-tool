class Task < ApplicationRecord
  belongs_to :milestone

  validates :name, presence: true, length: {minimum:  4, maximum:  40}

  has_many :sub_tasks, dependent: :destroy
  
  def update_complete
    return if self.sub_tasks.blank?
    sum = 0
    self.sub_tasks.each {|sub_task|
      sum += 1 if sub_task.complete == true
    }
    sum == self.sub_tasks.count ? self.complete = true : self.complete = false 
  end

  def expenses
    user = User.find(self.assigned_to)
    rate = user.hourly_rate
    day = self.start_date
    duration = 1
    (self.end_date - self.start_date).to_i.times do
      day += 1.day
      duration += 1 if day.on_weekday?      
    end
    hours = duration * 8
    return hours*rate
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
