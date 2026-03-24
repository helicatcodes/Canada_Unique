# frozen_string_literal: true

class MessagePolicy < ApplicationPolicy
  # Only regular users and admins can send messages. MJR
  def create?
    admin? || user.user?
  end
end
