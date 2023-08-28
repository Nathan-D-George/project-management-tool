class Notification < ApplicationRecord
  belongs_to :project

  after_create_commit {broadcast_append_to "notifications"}

  enum kind: %i[notice alert]

  def member_added_notification(email)
    self.kind    = "notice"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%m")} - Added '#{email}' to #{Project.find(self.project_id).name}"
  end

  def member_removed_notification(email)
    self.kind    = "alert"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%M")} - Removed '#{email}' from #{Project.find(self.project_id).name} "
  end

  def milestone_created_notification(name)
    self.kind    = "notice"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%M")} - New milestone '#{name}' created for #{Project.find(self.project_id).name} "
  end

  def milestone_updated_notification(name)
    self.kind    = "notice"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%M")} - Milestone '#{name}' updated "
  end

  def milestone_deleted_notification(name)
    self.kind    = "alert"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%M")} - Milestone '#{name}' deleted from #{Project.find(self.project_id).name} "
  end

  def task_created_notification(name)
    self.kind    = "notice"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%M")} - task '#{name}' created for #{Project.find(self.project_id).name} "
  end

  def task_updated_notification(name)
    self.kind    = "notice"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%M")} - Task '#{name}' updated "
  end

  def task_deleted_notification(name)
    self.kind    = "alert"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%M")} - Task '#{name}' deleted from #{Project.find(self.project_id).name} "
  end

  def project_created_notification
    self.kind    = "notice"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%m")} - New project created: '#{Project.find(self.project_id).name}' "
  end

  def project_edited_notification
    self.kind     = "notice"
    self.message = "#{DateTime.now.strftime("%Y %b %d %Hh%m")} - '#{Project.find(self.project_id).name}' edited "
  end

end
