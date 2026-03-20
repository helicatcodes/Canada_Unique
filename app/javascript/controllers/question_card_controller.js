import { Controller } from "@hotwired/stimulus"

// [HW] Manages the per-card edit/saved toggle for each reflection question.
// On connect: if the questionnaire is submitted, all cards lock into read-only mode (no icons).
// If not submitted: cards with a saved answer start in saved mode (text + pen icon),
// empty cards start in edit mode (textarea + Save button).
export default class extends Controller {
  // [HW] Values passed from data attributes on the card element.
  //   questionnaireId / questionId — used to build the PATCH URL for per-card saves
  //   submitted — true when the questionnaire has been submitted; locks all cards to read-only
  static values = { questionnaireId: Number, questionId: Number, submitted: Boolean }

  // [HW] Targets:
  //   display   — <p> showing the saved answer text (visible in saved + locked mode)
  //   editor    — wrapper div containing the textarea (visible in edit mode only)
  //   editBtn   — borderless pen icon (visible in saved mode; hidden when locked or in edit mode)
  //   saveBtn   — Save button (visible in edit mode only; hidden when locked)
  //   textarea  — the actual <textarea> input
  static targets = ["display", "editor", "editBtn", "saveBtn", "textarea"]

  connect() {
    if (this.submittedValue) {
      // [HW] Questionnaire is submitted — show answer text, hide ALL interactive controls
      this.#showLockedMode()
    } else {
      // [HW] Always start in saved mode (pen icon visible), whether or not there is an answer.
      // Empty cards show "—". The student taps the pen to open a card for editing.
      this.#showSavedMode()
    }
  }

  edit() {
    // [HW] Safety guard: editing is not allowed once the questionnaire is submitted.
    // The pen icon is hidden in locked mode anyway, but this prevents any edge-case call.
    if (this.submittedValue) return
    this.#showEditMode()
    this.textareaTarget.focus()
  }

  save() {
    // [HW] Safety guard: saving is blocked in locked mode
    if (this.submittedValue) return

    const text      = this.textareaTarget.value
    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    // [HW] FormData lets us reuse the existing params[:answers] hash format on the Rails side
    const body = new FormData()
    body.append(`answers[${this.questionIdValue}]`, text)

    // [HW] Accept: application/json tells the controller to return { ok: true }
    // instead of redirecting, so the page doesn't reload after a per-card save
    fetch(`/questionnaires/${this.questionnaireIdValue}`, {
      method: "PATCH",
      headers: { "X-CSRF-Token": csrfToken, "Accept": "application/json" },
      body
    }).then(response => {
      if (response.ok) {
        // [HW] Update the display text with what the student just typed, then flip to saved mode
        this.displayTarget.textContent = text
        this.#showSavedMode()
      }
    })
  }

  // — Private helpers —

  #showLockedMode() {
    // [HW] Read-only: show the answer text, hide the pen icon and the entire editor.
    // Used when the questionnaire is submitted — student can see their answers but not change them.
    const saved = this.textareaTarget.value.trim()
    this.displayTarget.textContent = saved || "—"
    this.displayTarget.classList.remove("d-none")
    this.editBtnTarget.classList.add("d-none")
    this.editorTarget.classList.add("d-none")
    this.saveBtnTarget.classList.add("d-none")
  }

  #showSavedMode() {
    // [HW] Saved but still editable: show the answer text and the pen icon; hide the editor
    const saved = this.textareaTarget.value.trim()
    this.displayTarget.textContent = saved || "—"
    this.displayTarget.classList.remove("d-none")
    this.editBtnTarget.classList.remove("d-none")
    this.editorTarget.classList.add("d-none")
    this.saveBtnTarget.classList.add("d-none")
  }

  #showEditMode() {
    // [HW] Edit mode: show the textarea and Save button; hide the display text and pen icon
    this.displayTarget.classList.add("d-none")
    this.editBtnTarget.classList.add("d-none")
    this.editorTarget.classList.remove("d-none")
    this.saveBtnTarget.classList.remove("d-none")
  }
}
