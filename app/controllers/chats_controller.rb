class ChatsController < ApplicationController
  def create
    @chat = current_user.chats.build
    authorize @chat # Check if the current user is allowed to start a chat. MJR
    
    user_name = current_user.display_name
    welcome = "Hey #{user_name}! I'm Lucy — super excited you're here! Moving to Canada as a teenager is such a big deal, and I want you to know you've totally got this. I'm here whenever you want to chat — whether it's about school, making friends, missing home, or just anything on your mind. How are you feeling about everything so far?"
    
    @chat.save!
    @chat.messages.create!(role: "assistant", content: welcome)
    redirect_to chat_path(@chat)
  end

  def show
    # Use Chat.find so Pundit can handle access control. MJR
    @chat = Chat.find(params[:id])
    # Check if the current user is allowed to view this chat. MJR
    authorize @chat
    @messages = @chat.messages.order(:created_at)
  end
end
