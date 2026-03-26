class PhotosController < ApplicationController
  before_action :set_photo, only: %i[update destroy toggle_share]

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    # Check if the current user is allowed to upload photos. MJR
    authorize @photo
    if @photo.save
      redirect_to in_canada_path(active_tab: "gallery"), notice: "Photo uploaded!"
    else
      redirect_to in_canada_path(active_tab: "gallery"), alert: "Upload failed."
    end
  end

  def update
    # Check if the current user is allowed to update this photo. MJR
    authorize @photo
    # [HW] Edit modal allows updating location, description, and optionally a new image.
    # [HW] Image is only attached if the user actually picks a new file — omitting it keeps the existing one.
    attrs = { description: photo_params[:description], location: photo_params[:location] }
    attrs[:image] = photo_params[:image] if photo_params[:image].present?
    if @photo.update(attrs)
      # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
      redirect_to in_canada_path(active_tab: "gallery"), notice: "Photo updated!", status: :see_other
    else
      redirect_to in_canada_path(active_tab: "gallery"), alert: "Update failed.", status: :see_other
    end
  end

  def destroy
    # Check if the current user is allowed to delete this photo. MJR
    authorize @photo
    @photo.destroy
    # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
    redirect_to in_canada_path(active_tab: "gallery"), notice: "Photo deleted.", status: :see_other
  end

  # Toggles the shared flag: !@photo.shared flips true→false or false→true
  def toggle_share
    # Check if the current user is allowed to share/unshare this photo. MJR
    authorize @photo
    @photo.update(shared: !@photo.shared)
    # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
    redirect_to in_canada_path(active_tab: "gallery"), status: :see_other
  end

  private

  # Use Photo.find (not scoped to current_user) so Pundit can handle access control. MJR
  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image, :description, :location)
  end
end
