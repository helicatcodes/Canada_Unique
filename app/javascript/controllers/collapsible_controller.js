// Generic collapsible controller.
// Tapping the element with data-action="collapsible#toggle" shows/hides
// the content target and toggles the button label.
// Button labels default to "Show tasks" / "Hide tasks" but can be overridden
// via data-collapsible-show-label-value and data-collapsible-hide-label-value.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "chevron"]
  static values = {
    showLabel: { type: String, default: "Show tasks" },
    hideLabel: { type: String, default: "Hide tasks" }
  }

  toggle() {
    const hidden = this.contentTarget.classList.toggle("collapsible--hidden")
    this.chevronTarget.textContent = hidden ? this.showLabelValue : this.hideLabelValue
  }
}
