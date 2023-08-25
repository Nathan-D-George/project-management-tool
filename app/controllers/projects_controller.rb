class ProjectsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :logged_in_only
  before_action :project_leaders_only, only: [:edit, :delete, :add_member, :remove_member]
  $proj_id = nil
  $user_id = nil

  def new
    @project  = Project.new
    @users    = User.all_except(current_user)
  end

  def create
    project = Project.new
    project.description = params[:project][:description]
    project.attachments = params[:project][:attachments] if params[:project][:attachments].present?
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
      participant = Participant.new
      participant.user_id = current_user.id
      participant.project_id = project.id
      participant.save
      redirect_to show_project_path(id: project.id)
    else
      flash[:alert]  = 'Something went wrong'
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
    @users   = User.all_except(current_user)
    $proj_id = params[:id].to_i
    @members = @project.members
    @non_members = @project.non_members
    @milestones = Milestone.all.where(project_id: @project.id)
    console
  end

  def assign_job
    @user    = User.find(params[:id].to_i)
    @project = Project.find($proj_id)
    $user_id = params[:id].to_i
  end

  def add_member
    return if Project.find($proj_id).leader != current_user.id
    user        = User.find($user_id)
    user.job    = params[:user][:job]
    user.set_hourly_rate
    participant = Participant.new
    participant.user_id    = $user_id
    participant.project_id = $proj_id

    if participant.save
      flash[:notice] = "Added member to project"
      if user.save
        flash[:notice] = "Assigned #{user.email} job"
      end
    else
      flash[:alert]  = "Something went wrong"
    end
    redirect_to show_project_path(id: $proj_id)
  end

  def remove_member
    return if Project.find($proj_id).leader != current_user.id
    user = User.find(params[:id].to_i)
    user.job = "unemployed"
    user.set_hourly_rate
    user.save
    @participant = Participant.where(user_id: user.id, project_id: $proj_id).first
    if user.id != Project.find($proj_id).leader
      @participant.destroy
      flash[:notice] = "Removed member to project"
    end
    redirect_to show_project_path(id: $proj_id) 
  end

  def edit
    @project = Project.find(params[:id])
    @users   = User.all_except(current_user)
    $proj_id = params[:id].to_i
  end

  def update
    project = Project.find($proj_id)
    project.description = params[:project][:description]
    project.name        = params[:project][:name]    
    project.budget      = params[:project][:budget]
    start_parts         = [params[:project][:start_year],params[:project][:start_month],params[:project][:start_day]]
    project.start_date  = start_parts.join('/').to_date if start_parts.join('/').to_date > project.start_date
    end_parts           = [params[:project][:end_year],params[:project][:end_month],params[:project][:end_day]]
    project.end_date    = end_parts.join('/').to_date   if end_parts.join('/').to_date > project.start_date
    if project.save
      flash[:notice] = 'Project successfully updated'
      check_end_dates(project.id)
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

  def get_schedule
    @project = Project.find(params[:id])
    @milestones = @project.milestones
    @tasks = []
    @milestones.each {|milestone| @tasks.append(milestone.tasks) }
    today = Date.today
    @time_completed     = (today - @project.start_date)/(@project.end_date - @project.start_date).to_f * 100
    rate_of_work        = @project.percent_complete.to_f / @time_completed
    days_left           = (@project.end_date - today).to_f / rate_of_work
    @predicted_end_date = today + days_left
  end

  def get_budget
    @project  = Project.find(params[:id])
    @milestones = @project.milestones
    @milestone_expenses = []
    @task_expenses      = []
    @tasks = []
    @all_expenses = []
    @milestones.each {|milestone|
      @milestone_expenses.append(milestone.expenses)
      @all_expenses.append({milestone: milestone.name, 
        expense: number_to_currency(milestone.expenses, :unit=>'R ', :separator=>',', :delimiter=>' '), 
        budget:  number_to_currency(milestone.budget,   :unit=>'R ', :separator=>',', :delimiter=>' ')})
      @tasks.append(milestone.tasks)
      milestone.tasks.each {|task|
        @task_expenses.append(task.expenses)
        @all_expenses.append({task: task.name, expense: number_to_currency(task.expenses, :unit=>'', :separator=>',', :delimiter=>' ')})
      }
    }
    @project_expenses   = number_to_currency(@project.expenses, :unit=>'R ')
    @project.save
    console
  end

  private

  def project_leaders_only
    redirect_to show_project_path(id: $proj_id), alert: 'Project leaders only.' if current_user.role != "leader"
  end
  
end
