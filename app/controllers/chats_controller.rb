class ChatsController < ApplicationController
  before_action :authenticate_user!
  def create
    @chat = current_user.chats.create!
    user_name = current_user.name.presence || current_user.email.split("@").first
    welcome = "Hey #{user_name}! I'm Lucy 🍁 — super excited you're here! Moving to Canada as a teenager is such a big deal, and I want you to know you've totally got this. I'm here whenever you want to chat — whether it's about school, making friends, missing home, or just anything on your mind. How are you feeling about everything so far?"
    @chat.messages.create!(role: "assistant", content: welcome)
    redirect_to chat_path(@chat)
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @messages = @chat.messages.order(:created_at)
  end
end
