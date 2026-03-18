class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @chat = current_user.chats.find(params[:chat_id])

    # Save the user's message NVD
    @chat.messages.create!(role: "user", content: params[:content])

    # Get full chat history and send to AI NVD
    history = @chat.messages.order(:created_at).map do |m|
      { role: m.role, content: m.content }
    end

    # Call RubyLLM NVD
    llm_chat = RubyLLM.chat(model: "claude-sonnet-4-20250514")
    llm_chat.ask(history.last[:content])

    # Get the assistant's reply from the last message
    ai_content = llm_chat.messages.last.content

    # Save assistant response NVD
    @chat.messages.create!(role: "assistant", content: ai_content)

    redirect_to chat_path(@chat)
  end
end
