class LikesController < ApplicationController
  def create
    # [HW] Find the photo this like belongs to via the nested route param :photo_id
    @photo = Photo.find(params[:photo_id])
    # [HW] Toggle behaviour: if the user already liked this photo, remove the like;
    # otherwise create one. This means a single POST route handles both like and unlike.
    existing = current_user.likes.find_by(photo: @photo)
    if existing
      existing.destroy
    else
      @photo.likes.create(user: current_user)
    end
    # [HW] status: :see_other (303) required for Turbo to follow POST redirects correctly
    redirect_to in_canada_path, status: :see_other
  end
end
