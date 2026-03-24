# frozen_string_literal: true

class LikePolicy < ApplicationPolicy
  # Only regular users and admins can like photos. Viewers are read-only. MJR
  def create?
    return false if user.viewer?
    admin? || user.user?
  end
end
