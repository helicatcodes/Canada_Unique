import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "input", "submit", "typing"]

  connect() {
    this.scrollToBottom()
  }

  showTyping() {
    this.typingTarget.hidden = false
    this.submitTarget.disabled = true
    this.scrollToBottom()
  }

  hideTyping() {
    this.typingTarget.hidden = true
    this.submitTarget.disabled = false
    this.inputTarget.value = ""
    this.inputTarget.focus()
    this.scrollToBottom()
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.submitTarget.click()
    }
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
