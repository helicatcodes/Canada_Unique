class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def pre_canada
    return unless current_user.departure_date.present?

    @countdown = (current_user.departure_date - Date.today).to_i

    # t1 = Time.current
    # t2 = current_user.departure_date
    # @countdown = (t1 - t2).to_i
  end

  def in_canada
    # as a user I can upload photos
    # as a user i can view uploaded pictures in my gallery
    # as a user i can view a shared feed of pictures
    # # # retrieve all pics from db and organize in gallery
  end

  def post_canada
    answers = current_user.questionnaires.first.answers.map(&:text).join("\n")
    ruby_llm_chat = RubyLLM.chat
    ruby_llm_chat.with_instructions(prompt)
    @summary = ruby_llm_chat.ask("Summarize the #{answers} of the qestionnare and give me advice")
    puts @summary.content
  end

  # Renders the profile page for the logged-in user. MJR
  def profile
  end

  private

  def prompt
  <<-PROMPT
  You are a life coach specialized in personal development of youngsters.

  I am a student from Germany that just came back from a one year exchange from Canada.

  Give ma advice if I feel bad or have issues.

  Give me next steps where I feel I have made progress during my stay in Canada.
  PROMPT
  end
end
