# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  # Only admins can compose and send notifications. MJR
  def new?
    admin?
  end

  def create?
    admin?
  end
end
