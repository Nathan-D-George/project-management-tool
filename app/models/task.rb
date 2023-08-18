class Task < ApplicationRecord
  belongs_to :milestone

  validates :name, presence: true, length: {minimum:  4, maximum:  40}

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
