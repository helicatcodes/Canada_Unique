class LikesController < ApplicationController
  def create
    # [HW] Find the photo this like belongs to via the nested route param :photo_id
    @photo = Photo.find(params[:photo_id])
    # [HW] Toggle behaviour: if the user already liked this photo, remove the like;
    # otherwise create one. A single POST route handles both like and unlike.
    existing = current_user.likes.find_by(photo: @photo)
    if existing
      existing.destroy
    else
      @photo.likes.create(user: current_user)
    end
    # [HW] Reload @photo so .likes reflects the just-made change, not a stale cached value
    @photo.reload
    # [HW] respond_to lets Rails pick the right response format:
    # [HW]   turbo_stream → renders create.turbo_stream.erb (updates the reactions bar in place)
    # [HW]   html         → falls back to a full redirect for browsers without Turbo
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to in_canada_path, status: :see_other }
    end
  end
end
