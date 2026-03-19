class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def pre_canada
    return unless current_user.departure_date.present?

    @countdown = (current_user.departure_date - Date.today).to_i

    # t1 = Time.current
    # t2 = current_user.departure_date
    # @countdown = (t1 - t2).to_i
  end

  def in_canada
    # [HW] @my_photos: only the current user's photos (for their private gallery)
    # [HW] @feed_photos: all photos marked as shared by any user (for the community feed)
    # [HW] @photo: blank photo object needed by the upload form
    @my_photos   = current_user.photos.order(created_at: :desc)
    # [HW] includes(:user, :likes, comments: :user) loads all likes, comments and their authors
    # [HW] for every feed photo upfront in one go (eager-loading), so the view doesn't hit the
    # [HW] database again for each individual photo card — preventing N+1 queries
    @feed_photos = Photo.includes(:user, :likes, comments: :user).where(shared: true).order(created_at: :desc)
    @photo       = Photo.new
  end

  def post_canada
  end

  # Renders the profile page for the logged-in user. MJR
  def profile
  end
end
