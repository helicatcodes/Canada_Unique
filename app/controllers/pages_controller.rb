class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def pre_canada
    raise
    return unless current_user.departure_date.present?

    @countdown = (current_user.departure_date - Date.today).to_i

    # t1 = Time.current
    # t2 = current_user.departure_date
    # @countdown = (t1 - t2).to_i
  end

  def in_canada
    # as a user I can upload photos
    # as a user i can view uploaded pictures in my gallery
    # as a user i can view a shared feed of pictures
    # # # retrieve all pics from db and organize in gallery
  end
end
