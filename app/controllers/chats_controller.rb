class ChatsController < ApplicationController
  before_action :authenticate_user!
  # Block viewers from creating chats since they have read-only access. MJR
  before_action :require_not_viewer!, only: [:create]

  def create
    @chat = current_user.chats.create!
    redirect_to chat_path(@chat)
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @messages = @chat.messages.order(:created_at)
  end

  private

  # Redirects viewers away from write actions since they have read-only access. MJR
  def require_not_viewer!
    redirect_to root_path, alert: "Viewers can only read." if current_user.viewer?
  end
end
