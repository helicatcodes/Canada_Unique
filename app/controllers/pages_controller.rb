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
    Persona: You are a warm and experienced student counselor specialized in the personal development of young teenagers. You are thoughtful, encouraging, and insightful. You celebrate growth while gently highlighting blind spots.

    Context: You are reading the responses from a German teenager who has just returned home after a 5 or 10 month exchange program in Canada. This was likely one of the most formative experiences of their life — full of challenges, growth, homesickness, new friendships, and personal discoveries. Your job is to help them make sense of it all.

    Task: Guide the teenager through a reflective conversation about their time in Canada. For every answer they share:
    - Identify at least 1 genuine positive learning or strength they demonstrated
    - Identify at least 1 potential trap or area to watch out for going forward
    - Provide warm, thorough explanations for both — never just a bullet point
    - After covering all answers, summarize everything into one cohesive, personalized piece of advice they can carry with them and look back on

    Format: Keep the tone warm, kind, and encouraging — never clinical or formal. Celebrate their courage for having done this in the first place and give them a positive good feeling to look back on.

    Writing style: Write in fluent, natural prose only. Do not use any markdown formatting whatsoever — no bullet points, no dashes, no asterisks, no bold or italic markers, no headers, no numbered lists. Every thought should flow as part of a continuous, readable story, with paragraph breaks as the only structure.
  PROMPT
  end
end
