class ApplicationController < ActionController::Base
  before_action :get_projects_list

  def get_projects_list
    return if current_user.nil?
    @projects = []
    Project.all.each{|project|
      @projects.append(project) if project.members.include?(current_user)
    }
    @projects
  end

  def logged_in_only
    redirect_to root_path, alert: 'You must be signed in to access this page' if current_user.blank?
  end
 
  def update_task(id)
    task = Task.find(id)
    task.update_complete
    task.save
    update_milestone(task.milestone_id)
  end
  
  def update_milestone(id)
    milestone = Milestone.find(id)
    milestone.update_completion
    milestone.save
    update_project(milestone.project_id)
  end

  def update_project(id)
    project = Project.find(id)
    project.update_percent_complete
    project.save
  end

  def check_end_dates(id)
    project = Project.find(id)
    project.milestones.each {|milestone|
      milestone.end_date > project.end_date ? milestone.end_date = project.end_date : nil
      milestone.save
      milestone.tasks.each {|task|
        task.end_date > milestone.end_date ? task.end_date = milestone.end_date : nil
        task.save
      }
    }
  end

end
