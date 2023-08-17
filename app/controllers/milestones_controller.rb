class MilestonesController < ApplicationController
  before_action :logged_in_only
  $project_id = nil

  def new  
    project = Project.find(params[:id].to_i)
    redirect_to show_project_path(id: params[:id]) if current_user.id != project.leader
    # @milestones = Milestone.all
    @milestone  = Milestone.new
    @project    = Project.find(params[:id].to_i)
    $project_id = params[:id]
  end

  def create
    milestone = Milestone.new
    project   = Project.find($project_id)
    milestone.name        = params[:milestone][:name]
    milestone.description = params[:milestone][:description]
    start_date_parts      = [ params[:milestone][:start_day], params[:milestone][:start_month], params[:milestone][:start_year] ]
    date  = start_date_parts.join("/").to_date
    milestone.start_date  = date if date >= project.start_date

    end_date_parts        = [ params[:milestone][:end_day], params[:milestone][:end_month], params[:milestone][:end_year] ]
    date    = end_date_parts.join("/").to_date
    milestone.end_date    = date if date >= project.start_date

    milestone.baseline_start_date  = start_date_parts.join("/").to_date
    milestone.baseline_end_date    = end_date_parts.join("/").to_date

    milestone.project_id = project.id
    
    if milestone.save
      flash[:notice] = 'Successfully added milestone'
      redirect_to show_milestone_path(id: milestone.id)
    else
      flash[:alert]  = 'Something went wrong'
      render :new
    end
  end

  def edit
    @milestone = Milestone.find(params[:id])
    @project   = Project.find(@milestone.project_id)
  end

  def update
    milestone = Milestone.find(params[:id])
    debugger
  end

  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy
    flash[:notice] = 'Deleted Milestone'
    redirect_to root_path
  end

  def show
    @milestone = Milestone.find(params[:id].to_i)
    @project   = Project.find(@milestone.project_id)
  end


end
