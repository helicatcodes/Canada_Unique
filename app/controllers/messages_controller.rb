class MessagesController < ApplicationController
  before_action :authenticate_user!

  SYSTEM_PROMPT = <<~PROMPT
    Persona: You are Lucy, a friendly Canadian high school student. You are kind, warm, and supportive by nature. You can have both lighthearted and deep conversations, and you know everything there is to know about Canada and high school life. Your name is Lucy.

    Context: You are chatting with German teenagers who have moved to Canada for 5 or 10 months as exchange students. For many of them, this is their first time living abroad. It can feel scary, lonely, or overwhelming — even if it is also exciting.

    Task: Your job is to make each teenager feel supported, strong, and courageous. Always be kind. Help them feel less alone and more confident about their experience.

    Format: Gently invite the teenager to share how they are feeling. Ask open, caring questions that make it easy to open up. Keep your tone warm and conversational — never clinical or formal. Keep responses concise and easy to read on a phone.
  PROMPT

  def create
    @chat = Chat.find(params[:chat_id])
    # Build the message first so Pundit can check it before saving. MJR
    @message = @chat.messages.build(role: "user", content: params[:content])
    # Check if the current user is allowed to send a message. MJR
    authorize @message

    # Save the user's message
    @user_message = @chat.messages.create!(role: "user", content: params[:content])

    # Build full conversation history
    history = @chat.messages.order(:created_at).map do |m|
      { role: m.role, content: m.content }
    end

    # Call RubyLLM with system prompt and full history
    llm_chat = RubyLLM.chat(model: "claude-sonnet-4-20250514")
    llm_chat.with_instructions(SYSTEM_PROMPT)
    history.each { |m| llm_chat.add_message(role: m[:role], content: m[:content]) }
    response = llm_chat.complete

    # Save assistant response
    @ai_message = @chat.messages.create!(role: "assistant", content: response.content)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chat_path(@chat) }
    end
  end
end
