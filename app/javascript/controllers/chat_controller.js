import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "input", "submit", "typing"]

  connect() {
    this.scrollToBottom()

    // Auto-scroll whenever a new message node is added to the conversation —
    // this fires after the turbo stream DOM update, solving the timing issue
    this._observer = new MutationObserver(() => this.scrollToBottom())
    this._observer.observe(this.messagesTarget, { childList: true, subtree: true })
  }

  disconnect() {
    this._observer?.disconnect()
  }

  showTyping() {
    // Optimistically render the user's message immediately on submit,
    // before waiting for the server response
    const text = this.inputTarget.value.trim()
    if (!text) return

    const bubble = document.createElement("div")
    bubble.className = "chat-message chat-message--user"
    bubble.innerHTML = `<div class="chat-bubble">${this._escapeHtml(text)}</div>`
    this.messagesTarget.appendChild(bubble)

    this.inputTarget.value = ""
    this.typingTarget.hidden = false
    this.submitTarget.disabled = true
    this.scrollToBottom()
  }

  hideTyping() {
    this.typingTarget.hidden = true
    this.submitTarget.disabled = false
    this.inputTarget.focus()
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      if (this.inputTarget.value.trim()) {
        this.submitTarget.click()
      }
    }
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  // Prevent XSS in the optimistically rendered bubble
  _escapeHtml(text) {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
  }
}
