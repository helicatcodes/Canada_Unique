# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  # Only regular users and admins can post comments. MJR
  def create?
    admin? || user.user?
  end

  # Only the comment owner or an admin can delete. Viewers are read-only. MJR
  def destroy?
    return false if user.viewer?
    admin? || record.user == user
  end
end
