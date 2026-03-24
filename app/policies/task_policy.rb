# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  # Only regular users and admins can update tasks. Viewers are read-only. MJR
  def update?
    return false if user.viewer?
    admin? || user.user?
  end
end
