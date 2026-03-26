// Generic collapsible controller.
// Tapping the element with data-action="collapsible#toggle" shows/hides
// the content target and toggles the button label between "Show tasks" / "Hide tasks".
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "chevron"]

  toggle() {
    const hidden = this.contentTarget.classList.toggle("collapsible--hidden")
    this.chevronTarget.textContent = hidden ? "Show tasks" : "Hide tasks"
  }
}
