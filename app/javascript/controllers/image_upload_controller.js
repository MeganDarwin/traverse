import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"]

  connect() {
    this.toggleButton()
  }

  toggleButton() {
    if (this.inputTarget.files.length > 0) {
      this.buttonTarget.disabled = false
      this.buttonTarget.classList.remove("btn-disabled")
      this.buttonTarget.classList.add("btn-primary")
    } else {
      this.buttonTarget.disabled = true
      this.buttonTarget.classList.add("btn-disabled")
      this.buttonTarget.classList.remove("btn-primary")
    }
  }

  clearInput() {
    this.inputTarget.value = ""
    this.toggleButton()
  }
}