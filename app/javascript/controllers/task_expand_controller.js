// Expand/collapse controller for preparation checklist cards.
// Tapping anywhere on a card toggles the full description visibility
// and rotates the chevron to indicate open/closed state.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["desc", "chevron"]

  toggle() {
    this.descTarget.classList.toggle("prep-checklist__item-desc--expanded")
    this.chevronTarget.classList.toggle("prep-checklist__chevron--open")
  }
}
