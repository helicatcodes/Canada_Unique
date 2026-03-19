# Notifier class for admin broadcasts. Uses noticed gem to deliver notifications to all users. MJR
class AdminBroadcastNotifier < Noticed::Event
  # Store each notification as a database record in noticed_notifications. MJR
  deliver_by :database

  # Required by noticed v2 for STI - stores type as "AdminBroadcastNotifier::Notification" in the database. MJR
  class Notification < Noticed::Notification
  end
end
