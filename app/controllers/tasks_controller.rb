class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def show
    to_find_id = params[:id].to_i
    @task = Task.all.find { |task| task.id == to_find_id }
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      # Provides completed date if is created from form as 'Complete'
      @task.update(completed_on: Time.now) if @task.status == "Complete"
      redirect_to tasks_path
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task.update(task_params)
      if @task.status == "Incomplete"
        @task.update(completed_on: nil)
      else # is complete
        # only set to Time.now if the task does not already have a completed date
        @task.update(completed_on: Time.now) if @task.completed_on.nil?
      end
      redirect_to task_path(@task.id)
    else
      render :edit
    end
  end

  def mark_complete
    @task = Task.find(params[:id])
    @task.update(status: "Complete", completed_on: Time.now)
    @task.save
    redirect_to tasks_path
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to tasks_path
  end

  private

  def task_params
    return params.require(:task).permit(:name, :status, :description, :due,
      :completed_on)
  end
end
