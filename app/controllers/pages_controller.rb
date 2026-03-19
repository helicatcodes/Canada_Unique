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
    @photos = Photo.includes(:user).order(created_at: :desc)
    @photo = Photo.new
  end

  def post_canada
  end

  # Renders the profile page for the logged-in user. MJR
  def profile
  end
end
