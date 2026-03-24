class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # When a user is not authorized, redirect them to the home page with an alert. MJR
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :name])
  end

  private

  def user_not_authorized
    redirect_to root_path, alert: "Not authorized."
  end

  # Returns the student the current user is acting as.
  # For viewers (parents), this is their linked child. For everyone else, it's themselves. MJR
  def effective_user
    current_user.viewer? ? current_user.linked_user : current_user
  end
  helper_method :effective_user
end
