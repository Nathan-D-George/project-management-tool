class ApplicationController < ActionController::Base
  before_action :get_projects_list

  def get_projects_list
    @projects = Project.all
  end
end
