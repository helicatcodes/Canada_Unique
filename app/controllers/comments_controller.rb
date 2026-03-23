class CommentsController < ApplicationController
  def create
    # [HW] Find the photo this comment belongs to via the nested route param :photo_id
    @photo = Photo.find(params[:photo_id])
    # [HW] Assign result to @comment so the turbo_stream partial can render it
    # [HW] Previously the result was discarded, causing a nil error in the partial
    @comment = @photo.comments.create(text: params[:comment][:text], user: current_user)
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
