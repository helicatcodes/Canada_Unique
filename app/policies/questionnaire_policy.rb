# frozen_string_literal: true

class QuestionnairePolicy < ApplicationPolicy
  # Only the owner or an admin can update a questionnaire. MJR
  def update?
    admin? || record.user == effective_user
  end
end
