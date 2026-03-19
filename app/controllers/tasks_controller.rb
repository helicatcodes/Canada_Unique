class TasksController < ApplicationController
  def pre_canada
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end
end
