class Notification < ApplicationRecord
  belongs_to :user
end

# [HW] Created notifications model as this seemed to be missing (NotificationsController only)
