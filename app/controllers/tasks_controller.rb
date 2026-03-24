class TasksController < ApplicationController
  def pre_canada
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    # Check if the current user is allowed to update tasks. MJR
    authorize @task
    @task.update(status: params[:task][:status])
    redirect_to pre_canada_path
  end
end
