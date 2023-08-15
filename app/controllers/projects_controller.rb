class ProjectsController < ApplicationController
  $temp_id = nil

  def new
    @project  = Project.new
    # @projects = Project.all
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
      redirect_to root_path #assign_project_members_path
    else
      flash[:alert]  = 'Something went wrong'
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
    @users   = User.all_except(current_user)
    $temp_id = params[:id].to_i
  end


  def add_members
    participant = Participant.new
    participant.user_id = params[:id]
    participant.project_id = $temp_id
    debugger
    if participant.save
      flash[:notice] = "Added member to project"
    else
      flash[:alert]  = "Something went wrong"
    end
    redirect_to root_path
  end

  def edit
    @project = Project.find(params[:id])
    @users   = User.all_except(current_user)
    $temp_id = params[:id].to_i
  end

  def update
    project = Project.find($temp_id)
    debugger
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    flash[:notice] = 'Project Successfully Destroyed'
  end

end
