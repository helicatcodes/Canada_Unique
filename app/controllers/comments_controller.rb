class CommentsController < ApplicationController
  def create
    # [HW] Find the photo this comment belongs to via the nested route param :photo_id
    @photo = Photo.find(params[:photo_id])
    # [HW] Assign to @comment (not just create) so the turbo stream view can render it
    @comment = @photo.comments.create(text: params[:comment][:text], user: current_user)
    # [HW] respond_to lets Rails pick the right response format:
    # [HW]   turbo_stream → renders create.turbo_stream.erb (no page reload)
    # [HW]   html         → falls back to a full redirect for browsers without Turbo
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to in_canada_path, status: :see_other }
    end
  end

  def destroy
    # [HW] Scope to current_user.comments so users can only delete their own comments
    @comment = current_user.comments.find(params[:id])
    # [HW] Capture the photo before destroying the comment — needed by the turbo stream view
    @photo = @comment.photo
    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to in_canada_path, status: :see_other }
    end
  end
end
