class NotificationsController < ApplicationController
  before_action :authorize_notification, only: %i[new create]

  # Loads all notifications for the current user, newest first. MJR
  def index
    @notifications = current_user.noticed_notifications
                                 .includes(:event)
                                 .order(created_at: :desc)
  end

  # Finds the notification belonging to the current user and marks it as read. MJR
  def show
    @notification = current_user.noticed_notifications.find(params[:id])
    @notification.mark_as_read!
  end

  # Renders the admin compose form. MJR
  def new
  end

  # Broadcasts the notification to every user in the database. MJR
  def create
    AdminBroadcastNotifier.with(
      title: params[:title],
      message: params[:message]
    ).deliver(User.all)

    redirect_to notifications_path, notice: "Notification sent to all users."
  end

  private

  # Uses Pundit to check if the current user can manage notifications. MJR
  def authorize_notification
    authorize :notification
  end
end
