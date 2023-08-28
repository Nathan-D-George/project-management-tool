class NotificationsController < ApplicationController
  def list
    @notifications = [] # Notification.all.order('id DESC')
    Project.all.each {|project|
      if project.members.include?(current_user)
        Notification.where(project_id: project.id).all.each{|noti|
          @notifications.append(noti)
        }
      end
    }
    console
  end

end
