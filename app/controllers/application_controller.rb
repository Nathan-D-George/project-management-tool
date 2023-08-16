class ApplicationController < ActionController::Base
  before_action :get_projects_list

  def get_projects_list
    @projects = Project.all
  end

  def logged_in_only
    redirect_to root_path, alert: 'You must be signed in to access this page' if current_user.blank?
  end
  

end
