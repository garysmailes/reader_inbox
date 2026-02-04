import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    // Ensure the URL field is always blank on load/refresh.
    this.inputTarget.value = ""
  }
}
