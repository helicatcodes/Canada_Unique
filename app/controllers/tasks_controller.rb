class TasksController < ApplicationController
  def pre_canada
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update(status: params[:task][:status])
    redirect_to pre_canada_path
  end
end
