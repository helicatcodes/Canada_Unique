class PhotosController < ApplicationController
  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    if @photo.save
      redirect_to in_canada_path, notice: "Photo uploaded!"
    else
      redirect_to in_canada_path, alert: "Upload failed."
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    @photo.destroy
    redirect_to in_canada_path, notice: "Photo deleted."
  end

  private

  def photo_params
    params.require(:photo).permit(:image, :description)
  end
end
