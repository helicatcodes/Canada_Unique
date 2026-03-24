class UsersController < ApplicationController
  def new
    @viewer = User.new
    # Check if the current user is an admin. MJR
    authorize @viewer
    # Load all students for the dropdown so the admin can pick who to link the viewer to. MJR
    @students = User.where(role: :user).order(:name, :email)
  end

  def create
    @viewer = User.new(viewer_params.merge(role: :viewer))
    # Check if the current user is an admin. MJR
    authorize @viewer
    if @viewer.save
      redirect_to profile_path, notice: "Viewer account created for #{@viewer.email}."
    else
      @students = User.where(role: :user).order(:name, :email)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def viewer_params
    params.require(:user).permit(:email, :password, :password_confirmation, :linked_user_id)
  end
end
