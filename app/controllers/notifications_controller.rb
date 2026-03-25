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

  # Renders the admin compose form with filter options. MJR
  def new
    @districts = User.where.not(district: [nil, ""]).distinct.pluck(:district).sort
    @cities    = User.where.not(city:     [nil, ""]).distinct.pluck(:city).sort
    @schools   = User.where.not(school:   [nil, ""]).distinct.pluck(:school).sort
  end

  # Broadcasts the notification to users matching the selected filters. MJR
  def create
    recipients = User.all
    recipients = recipients.where(district: params[:district]) if params[:district].present?
    recipients = recipients.where(city:     params[:city])     if params[:city].present?
    recipients = recipients.where(school:   params[:school])   if params[:school].present?

    AdminBroadcastNotifier.with(
      title: params[:title],
      message: params[:message]
    ).deliver(recipients)

    count = recipients.count
    redirect_to notifications_path, notice: "Notification sent to #{count} user(s)."
  end

  private

  # Uses Pundit to check if the current user can manage notifications. MJR
  def authorize_notification
    authorize :notification
  end
end
