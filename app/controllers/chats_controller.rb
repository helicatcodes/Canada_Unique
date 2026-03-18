class ChatsController < ApplicationController
  before_action :authenticate_user!
  def create
    @chat = current_user.chats.create!
    redirect_to chat_path(@chat)
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @messages = @chat.messages.order(:created_at)
  end
end
