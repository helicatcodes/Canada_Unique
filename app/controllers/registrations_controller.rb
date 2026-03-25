class RegistrationsController < Devise::RegistrationsController
  def create
    @token = Token.find_by(token: params[:user][:token])

    if @token.nil? || !@token.pending?
      redirect_to root_path, alert: "Invalid or expired invitation."
      return
    end

    super do |user|
      if user.persisted?
        @token.accepted!
      end
    end
  end
end
