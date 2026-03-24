class QuestionnairesController < ApplicationController
  before_action :set_questionnaire

  # Polled by the ai_summary Stimulus controller to check if the background job is done
  def status
    render json: {
      ready: @questionnaire.ai_summary.present?,
      html:  @questionnaire.ai_summary.present? ? helpers.simple_format(@questionnaire.ai_summary) : nil
    }
  end

  def update
    # Check if the current user is allowed to update this questionnaire. MJR
    authorize @questionnaire
    # [HW] params[:answers] is a hash of { question_id => answer_text } built by the form.
    # first_or_initialize finds an existing answer for the question or builds a new one in memory.
    # We then update the text and save. This handles both creating new answers and editing existing ones.
    if params[:answers].present?
      params[:answers].each do |question_id, text|
        question = @questionnaire.questions.find(question_id)
        answer = question.answers.first_or_initialize
        answer.update!(text: text)
      end
    end

    # [HW] Update the submitted flag whenever the param is present.
    # "true"  → student clicked the unlock button (submit)
    # "false" → student clicked the revert icon next to the Submitted badge (go back to draft)
    # When the param is absent (per-card Save fetch), submitted is left unchanged.
    if params.key?(:submitted)
      @questionnaire.update!(submitted: params[:submitted] == "true")
    end

    # [HW] The same update action is called in two different ways, so we need to respond differently
    # depending on who is calling:
    #
    #   1. The "Create Personal Growth Summary" button at the bottom of the page is a regular HTML
    #      form submit (button_to). When that fires, Rails should redirect back to /post_canada
    #      so the page reloads and the student sees the updated submitted state.
    #
    #   2. Each per-card "Save" button uses JavaScript fetch (via the question_card Stimulus
    #      controller) and sends Accept: application/json. We must NOT redirect for this caller —
    #      instead we return a tiny { ok: true } JSON response so the JS knows it succeeded
    #      and can flip the card to "saved" mode without touching the page.
    #
    # respond_to checks the Accept header to decide which branch to run.
    respond_to do |format|
      format.html do
        # [HW] Anchor the redirect so the page lands at the right section after reload instead
        # of jumping to the top:
        #   submitted: true  → scroll down to the summary panel ("ai-summary" anchor)
        #   submitted: false → scroll back to the questionnaire ("questionnaire" anchor)
        #   no submitted param (shouldn't reach HTML format from per-card save, but safe fallback)
        anchor = case params[:submitted]
                 when "true"  then "ai-summary"
                 when "false" then "questionnaire"
                 end
        redirect_to post_canada_path(anchor: anchor), notice: params[:submitted] == "true" ? "Questionnaire submitted!" : "Progress saved."
      end
      format.json { render json: { ok: true } }
    end
  end

  private

  # Use Questionnaire.find so Pundit can handle access control. MJR
  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:id])
  end
end
