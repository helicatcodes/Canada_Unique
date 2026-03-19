class PhotosController < ApplicationController
  before_action :set_photo, only: [:edit, :update, :destroy, :toggle_share]

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    if @photo.save
      redirect_to in_canada_path, notice: "Photo uploaded!"
    else
      redirect_to in_canada_path, alert: "Upload failed."
    end
  end

  def edit
  end

  def update
    if @photo.update(description: params[:photo][:description])
      # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
      redirect_to in_canada_path, notice: "Caption updated!", status: :see_other
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
    redirect_to in_canada_path, notice: "Photo deleted.", status: :see_other
  end

  # Toggles the shared flag: !@photo.shared flips true→false or false→true
  def toggle_share
    @photo.update(shared: !@photo.shared)
    # [HW] status: :see_other (303) is required for Turbo to follow PATCH/DELETE redirects correctly
    redirect_to in_canada_path, status: :see_other
  end

  private

  # Scopes to current_user.photos so users can only modify their own photos
  def set_photo
    @photo = current_user.photos.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image, :description)
  end
end
