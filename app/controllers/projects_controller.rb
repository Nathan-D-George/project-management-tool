class ProjectsController < ApplicationController
  before_action :logged_in_only
  before_action :project_leaders_only, only: [:edit, :delete, :add_member, :remove_member]
  $temp_id = nil

  def new
    @project  = Project.new
    @users    = User.all_except(current_user)
    console
  end

  def create
    project = Project.new
    project.description = params[:project][:description]
    project.name   = params[:project][:name]    
    project.budget = params[:project][:budget]
    start_parts    = [params[:project][:start_year],params[:project][:start_month],params[:project][:start_day]]
    project.start_date          = start_parts.join('/').to_date
    project.baseline_start_date = start_parts.join('/').to_date
    end_parts      = [params[:project][:end_year],params[:project][:end_month],params[:project][:end_day]]
    project.end_date          = end_parts.join('/').to_date
    project.baseline_end_date = end_parts.join('/').to_date
    project.leader = current_user.id
    if project.save
      flash[:notice] = 'Project successfully created'
      redirect_to show_project_path(id: project.id)
    else
      flash[:alert]  = 'Something went wrong'
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
    @users   = User.all_except(current_user)
    $temp_id = params[:id].to_i
    @members = @project.members
    @non_members = @project.non_members
    console
  end

  def add_member
    participant = Participant.new
    participant.user_id = params[:id]
    participant.project_id = $temp_id
    if participant.save
      flash[:notice] = "Added member to project"
    else
      flash[:alert]  = "Something went wrong"
    end
    redirect_to show_project_path(id: $temp_id)
  end

  def remove_member
    user = User.find(params[:id].to_i)
    @participant = Participant.where(user_id: user.id, project_id: $temp_id).first
    @participant.destroy
    flash[:notice] = "Removed member to project"
    redirect_to show_project_path(id: $temp_id) 
  end

  def edit
    @project = Project.find(params[:id])
    @users   = User.all_except(current_user)
    $temp_id = params[:id].to_i
  end

  def update
    project = Project.find($temp_id)
    project.description = params[:project][:description]
    project.name        = params[:project][:name]    
    project.budget      = params[:project][:budget]
    start_parts         = [params[:project][:start_year],params[:project][:start_month],params[:project][:start_day]]
    project.start_date  = start_parts.join('/').to_date
    end_parts           = [params[:project][:end_year],params[:project][:end_month],params[:project][:end_day]]
    project.end_date    = end_parts.join('/').to_date
    if project.save
      flash[:notice] = 'Project successfully updated'
      redirect_to show_project_path(id: project.id)
    else
      flash[:alert]  = 'Something went wrong'
      render 'new'
    end
    
  end

  def delete
    @project = Project.find(params[:id])
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    flash[:notice] = 'Project Successfully Destroyed'
  end

  private

  def project_leaders_only
    redirect_to show_project_path($temp_id), alert: 'You must be project leader to access this page' if current_user.role != "leader"
  end
  
end
