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
    self.complete = true if sum == self.sub_tasks.count
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
