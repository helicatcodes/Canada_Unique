class LikesController < ApplicationController
  def create
    # [HW] Find the photo this like belongs to via the nested route param :photo_id
    @photo = Photo.find(params[:photo_id])
    # Check if the current user is allowed to like photos. MJR
    authorize Like.new(user: current_user, photo: @photo)
    # [HW] Toggle behaviour: if the user already liked this photo, remove the like;
    # otherwise create one. A single POST route handles both like and unlike.
    existing = current_user.likes.find_by(photo: @photo)
    if existing
      existing.destroy
    else
      @photo.likes.create(user: current_user)
    end
    # [HW] reload so likes.size in the turbo stream partial reflects the change just made
    @photo.reload
    # [HW] respond_to lets Turbo choose: stream response keeps the modal open;
    # [HW] html fallback redirects normally when JavaScript is unavailable
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to in_canada_path, status: :see_other }
    end
  end
end
