class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def pre_canada
    @countdown = (current_user.departure_date - Date.today).to_i
    # t1 = Time.current
    # t2 = current_user.departure_date
    # @countdown = (t1 - t2).to_i
  end
end
