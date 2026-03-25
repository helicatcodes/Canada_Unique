class TokensController < ApplicationController

  skip_before_action :authenticate_user!, only: [:verify]

  def verify
    @token = Token.find_by(token: params[:token])
    if @token&.pending?
      redirect_to new_user_registration_path(token: params[:token])
    else
      redirect_to root_path, alert: "Your invitation has expired. Contact the admin"
    end
  end
end
