# frozen_string_literal: true

class PhotoPolicy < ApplicationPolicy
  # Any logged-in user (including viewers) can see all photos. MJR
  def index?
    true
  end

  def show?
    true
  end

  # Only regular users and admins can upload photos. MJR
  def create?
    admin? || user.user?
  end

  # Only the photo owner or an admin can edit/delete/share. Viewers are read-only. MJR
  def update?
    return false if user.viewer?
    admin? || record.user == user
  end

  def destroy?
    return false if user.viewer?
    admin? || record.user == user
  end

  def toggle_share?
    update?
  end
end
