class PhotosController < ApplicationController
  before_action :set_photo, only: [:edit, :update, :destroy, :toggle_share]

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    # Check if the current user is allowed to upload photos. MJR
    authorize @photo
    if @photo.save
      redirect_to in_canada_path, notice: "Photo uploaded!"
    else
      redirect_to in_canada_path, alert: "Upload failed."
    end
  end

  def edit
    # Check if the current user is allowed to edit this photo. MJR
    authorize @photo
  end

  def update
    # Check if the current user is allowed to update this photo. MJR
    authorize @photo
    if @photo.update(description: params[:photo][:description])
      # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
      redirect_to in_canada_path, notice: "Caption updated!", status: :see_other
    else
      render :edit
    end
  end

  def destroy
    # Check if the current user is allowed to delete this photo. MJR
    authorize @photo
    @photo.destroy
    # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
    redirect_to in_canada_path, notice: "Photo deleted.", status: :see_other
  end

  # Toggles the shared flag: !@photo.shared flips true→false or false→true
  def toggle_share
    # Check if the current user is allowed to share/unshare this photo. MJR
    authorize @photo
    @photo.update(shared: !@photo.shared)
    # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
    redirect_to in_canada_path, status: :see_other
  end

  private

  # Use Photo.find (not scoped to current_user) so Pundit can handle access control. MJR
  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image, :description)
  end
end
