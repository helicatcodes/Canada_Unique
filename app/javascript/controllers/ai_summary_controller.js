import { Controller } from "@hotwired/stimulus"

// Polls the server every 3 seconds until the AI summary is ready,
// then swaps the spinner out for the rendered summary HTML.
export default class extends Controller {
  static targets = ["spinner", "content"]
  static values  = { url: String }

  connect() {
    // Only start polling if the summary is still pending
    if (this.hasSpinnerTarget && this.spinnerTarget.dataset.pending === "true") {
      this.poll()
    }
  }

  disconnect() {
    clearTimeout(this._timer)
  }

  poll() {
    this._timer = setTimeout(() => {
      fetch(this.urlValue, { headers: { "Accept": "application/json" } })
        .then(r => r.json())
        .then(data => {
          if (data.ready) {
            this.spinnerTarget.classList.add("d-none")
            this.contentTarget.innerHTML = data.html
            this.contentTarget.classList.remove("d-none")
          } else {
            this.poll() // keep polling
          }
        })
        .catch(() => this.poll()) // retry on network error
    }, 3000)
  }
}
