# frozen_string_literal: true

class ChatPolicy < ApplicationPolicy
  # Only regular users and admins can start a chat. MJR
  def create?
    admin? || user.user?
  end

  # Viewers can view their linked user's chats. MJR
  def show?
    admin? || record.user == effective_user
  end
end
