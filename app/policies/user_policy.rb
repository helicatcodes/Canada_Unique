# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # Only admins can create viewer accounts. MJR
  def new?
    admin?
  end

  def create?
    admin?
  end
end
