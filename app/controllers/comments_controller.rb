class CommentsController < ApplicationController
  def create
    # [HW] Find the photo this comment belongs to via the nested route param :photo_id
    @photo = Photo.find(params[:photo_id])
    @photo.comments.create(text: params[:comment][:text], user: current_user)
    # [HW] status: :see_other (303) required for Turbo to follow POST/DELETE redirects correctly
    redirect_to in_canada_path, status: :see_other
  end

  def destroy
    # [HW] Scope to current_user.comments so users can only delete their own comments
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to in_canada_path, status: :see_other
  end
end
