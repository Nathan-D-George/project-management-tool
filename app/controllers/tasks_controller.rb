class TasksController < ApplicationController
  $milestone_id = nil
  
  def new
    redirect_to root_path if !correct_project_leader?(params[:id].to_i)
    @task         = Task.new(milestone_id: params[:id].to_i)
    @milestone    = Milestone.find(@task.milestone_id)
    @project      = Project.find(@milestone.project_id)
    $milestone_id = params[:id].to_i
    @members = []
    members  = Project.find(Milestone.find(params[:id].to_i).project_id).members
    members.each { |m| @members.append(m.email) }
  end

  def create
    milestone = Milestone.find($milestone_id)
    task      = Task.new
    task.name = params[:task][:name]
    task.description = params[:task][:description]
    days = get_start_and_end_dates_parts
    start_day        = days[:start].join('/').to_date
    end_day          = days[:end].join('/').to_date
    
    if start_day >= milestone.start_date && start_day < milestone.end_date
      task.start_date          = start_day
      task.baseline_start_date = start_day
    else
      task.start_date          = milestone.start_date
      task.baseline_start_date = milestone.start_date 
    end

    if end_day   >  milestone.start_date && end_day <=  milestone.end_date
      task.end_date          = end_day
      task.baseline_end_date = end_day
    else
      task.end_date          = milestone.end_date
      task.baseline_end_date = milestone.end_date
    end

    task.milestone_id = milestone.id
    task.assigned_to  = User.where(email: params[:task][:assignee]).first.id

    if task.save
      flash[:notice] = 'Task created'
      update_milestone(milestone.id)
      redirect_to show_task_path(id: task.id)
    else
      flash[:alert]  = 'Something went wrong'
      render :new
    end

  end

  def edit
    @task = Task.find(params[:id].to_i)
    @milestone = Milestone.find(@task.milestone_id)
    @project   = Project.find(@milestone.project_id)
    $task_id   = params[:id].to_i
    @members = []
    members  = Project.find(Milestone.find(@task.milestone_id).project_id).members
    members.each { |m| @members.append(m.email) }
    console
  end

  def update
    task = Task.find($task_id)
    task.name = params[:task][:name]
    task.description  = params[:task][:description]
    task.assigned_to  = User.where(email: params[:task][:assignee]).first.id if params[:task][:assignee] != "admin@admin.com"

    params[:task][:complete] == "true" ? task.complete = true : task.complete = false

    days = get_start_and_end_dates_parts
    start_day        = days[:start].join('/').to_date
    end_day          = days[:end].join('/').to_date

    if start_day >= task.baseline_start_date && start_day < task.baseline_end_date
      task.start_date = start_day
    end

    if (end_day > task.baseline_start_date && end_day <= task.baseline_end_date) 
      task.end_date = end_day
    end

    if task.save
      flash[:notice] = 'Task Updated'
      update_milestone(task.milestone_id)
      redirect_to show_task_path(id: task.id)
    else
      flash[:alert]  = 'Something went wrong'
      render :new
    end
  end

  def destroy
    @task = Task.find(params[:id].to_i)
    milestone = Milestone.find(@task.milestone_id)
    @task.destroy
    flash[:notice] = 'Task Deleted'
    redirect_to show_milestone_path(id: milestone.id)
  end

  def show
    @task      = Task.find(params[:id])
    @sub_tasks = SubTask.where(task_id: @task.id).all
    @milestone = Milestone.find(@task.milestone_id)
    @project   = Project.find(@milestone.project_id)
  end

  private

  def correct_project_leader?(milestone_id)
    milestone = Milestone.find(milestone_id)
    project   = Project.find(milestone.project_id)
    current_user.id == project.leader
  end

  def get_start_and_end_dates_parts
    start_day_parts  = [ params[:task][:start_day], params[:task][:start_month], params[:task][:start_year] ]
    end_day_parts    = [ params[:task][:end_day],   params[:task][:end_month], params[:task][:end_year] ]
    {start: start_day_parts, end: end_day_parts}
  end

end
