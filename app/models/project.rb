class Project < ApplicationRecord

  after_create_commit { broadcast_append_to "projects" }
  
  has_many_attached :attachments, dependent: :destroy

  has_many :milestones, dependent: :destroy
  
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
