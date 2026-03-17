class Message < ApplicationRecord
  belongs_to :chat

  enum :role, { user: "user", assistant: "assistant" } # set a role for the student = user and chatbot = assistant. NVD

end
