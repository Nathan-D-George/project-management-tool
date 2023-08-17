class TasksController < ApplicationController
  $task_id = nil
  def new
    @task = Task.new
  end

  def create
    task = Task.new
    debugger
  end

  def edit
    @task = Task.find(params[:id].to_i)
    $task_id = params[:id].to_i
  end

  def update
    task = Task.find($task_id)
    debugger
  end

  def destroy
    @task = Task.find(params[:id].to_i)
    @task.destroy
    flash[:notice] = 'Task Deleted'
    redirect_to root_path
  end

  def show
    @task = Task.find(params[:id])
  end
end
