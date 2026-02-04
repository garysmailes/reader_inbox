import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number }

  connect() {
    this.hideAfterTimeout()
  }

  dismiss() {
    this.hide()
  }

  hideAfterTimeout() {
    setTimeout(() => this.hide(), this.timeoutValue || 3000)
  }

  hide() {
    this.element.classList.add("ri-toast--hide")

    // remove from DOM after transition ends
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
