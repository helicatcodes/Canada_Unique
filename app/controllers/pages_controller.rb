class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def pre_canada
    # Use effective_user so viewers see their linked child's data. MJR
    return unless effective_user.departure_date.present?

    @countdown = (effective_user.departure_date - Date.today).to_i

    # t1 = Time.current
    # t2 = current_user.departure_date
    # @countdown = (t1 - t2).to_i
  end

  def in_canada
    # [HW] @my_photos: only the current user's photos (for their private gallery)
    # [HW] @feed_photos: all photos marked as shared by any user (for the community feed)
    # [HW] @photo: blank photo object needed by the upload form
    # Use effective_user so viewers see their linked child's photos. MJR
    @my_photos   = effective_user.photos.order(created_at: :desc)
    # [HW] includes(:user, :likes, comments: :user) loads all likes, comments and their authors
    # [HW] for every feed photo upfront in one go (eager-loading), so the view doesn't hit the
    # [HW] database again for each individual photo card — preventing N+1 queries
    @feed_photos = Photo.includes(:user, :likes, comments: :user).where(shared: true).order(created_at: :desc)
    @photo       = Photo.new
  end

  def post_canada
    # [HW] find_or_create the questionnaire so the page never crashes on first visit.
    # create_for also seeds all 8 predefined questions onto the new questionnaire.
    # Use effective_user so viewers see their linked child's questionnaire. MJR
    @questionnaire = effective_user.questionnaires.first ||
                     Questionnaire.create_for(effective_user)

    # [HW] includes(:answers) eager-loads all answers upfront so the view
    # can display each question's existing answer without extra DB queries.
    @questions = @questionnaire.questions.includes(:answers)

    # AI questionnaire summary logic
    if @questionnaire.submitted? && @questionnaire.ai_summary.blank?
      answers = @questionnaire.answers.map(&:text).join("\n")
      ruby_llm_chat = RubyLLM.chat(model: "claude-sonnet-4-6")
      ruby_llm_chat.with_instructions(prompt)
      @questionnaire.update(ai_summary: ruby_llm_chat.ask("Summarize the #{answers} of the qestionnare and give me advice").content)
    end
  end



  # Renders the profile page for the logged-in user. MJR
  def profile
  end

  # Handles avatar upload from the profile page.
  def update_avatar
    if params[:avatar].present? && current_user.update(avatar: params[:avatar])
      redirect_to profile_path, notice: "Profile photo updated."
    else
      redirect_to profile_path, alert: "Could not update photo."
    end
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
