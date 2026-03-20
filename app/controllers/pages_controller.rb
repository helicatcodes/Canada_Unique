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
    # [HW] @my_photos: only the current user's photos (for their private gallery)
    # [HW] @feed_photos: all photos marked as shared by any user (for the community feed)
    # [HW] @photo: blank photo object needed by the upload form
    @my_photos   = current_user.photos.order(created_at: :desc)
    # [HW] includes(:user, :likes, comments: :user) loads all likes, comments and their authors
    # [HW] for every feed photo upfront in one go (eager-loading), so the view doesn't hit the
    # [HW] database again for each individual photo card — preventing N+1 queries
    @feed_photos = Photo.includes(:user, :likes, comments: :user).where(shared: true).order(created_at: :desc)
    @photo       = Photo.new
  end

  def post_canada
    # [HW] find_or_create the questionnaire so the page never crashes on first visit.
    # create_for also seeds all 8 predefined questions onto the new questionnaire.
    @questionnaire = current_user.questionnaires.first ||
                     Questionnaire.create_for(current_user)

    # [HW] includes(:answers) eager-loads all answers upfront so the view
    # can display each question's existing answer without extra DB queries.
    @questions = @questionnaire.questions.includes(:answers)

    # [HW] AI summary logic — prep work for the summary feature (handled by teammate).
    # Kept here so it can be wired up once the questionnaire is submitted.
    # answers = current_user.questionnaires.first.answers.map(&:text).join("\n")
    # ruby_llm_chat = RubyLLM.chat
    # ruby_llm_chat.with_instructions(prompt)
    # @summary = ruby_llm_chat.ask("Summarize the #{answers} of the qestionnare and give me advice")
    # puts @summary.content
  end

  # Renders the profile page for the logged-in user. MJR
  def profile
  end

  # private

  # [HW] AI prompt for the summary feature — kept for when the AI summary is wired up.
  # def prompt
  # <<-PROMPT
  # You are a life coach specialized in personal development of youngsters.
  #
  # I am a student from Germany that just came back from a one year exchange from Canada.
  #
  # Give ma advice if I feel bad or have issues.
  #
  # Give me next steps where I feel I have made progress during my stay in Canada.
  # PROMPT
  # end
end
