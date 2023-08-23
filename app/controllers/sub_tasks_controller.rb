class SubTasksController < ApplicationController
  $task_id = nil

  def new
    @sub_task  = SubTask.new
    @task      = Task.find(params[:id].to_i)
    @milestone = Milestone.find(@task.milestone_id)
    @project   = Project.find(@milestone.project_id)
    $task_id   = params[:id].to_i
  end

  def create
    sub_task = SubTask.new
    
    sub_task.task_id     = $task_id
    sub_task.name        = params[:sub_task][:name]
    sub_task.description = params[:sub_task][:description]
    
    if sub_task.save
      flash[:notice] = 'Created Sub-Task'
      update_task(Task.find(sub_task.task_id).id)
      redirect_to show_sub_task_path(id: sub_task.id)
    else
      flash[:notice] = 'Something went wrong'
      redirect_to new_sub_task_path(id: sub_task.task_id)
    end
  end

  def edit
    @sub_task  = SubTask.find(params[:id].to_i)
    @task      = Task.find(@sub_task.task_id)
    @milestone = Milestone.find(@task.milestone_id)
    @project   = Project.find(@milestone.project_id)   
  end

  def update
    sub_task = SubTask.find(params[:id])
    sub_task.name        = params[:sub_task][:name]
    sub_task.description = params[:sub_task][:description]
    params[:sub_task][:complete] == "0" ? sub_task.complete = false : sub_task.complete = true
    if sub_task.save
      flash[:notice] = 'Sub-Task Updated'
      update_task(Task.find(sub_task.task_id).id)
      redirect_to show_sub_task_path(id: sub_task.id)
    else
      flash[:alert] = 'Something went wrong'
      redirect_to edit_sub_task_path(id: sub_task.id)
    end
  end

  def destroy 
    @sub_task = SubTask.find(params[:id])
    @task     = Task.find(@sub_task.task_id)
    @sub_task.destroy
    flash[:notice] = 'Successfully deleted sub_task'
    redirect_to show_task_path(id: @task.id)
  end

  def show
    @sub_task  = SubTask.find(params[:id])
    @task      = Task.find(@sub_task.task_id)
    @milestone = Milestone.find(@task.milestone_id)
    @project   = Project.find(@milestone.project_id)    
  end

  private

  def sub_task_params
    params.require('sub_task').permit(:name, :description, :complete)
  end

end
