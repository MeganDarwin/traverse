import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["body", "submitButton"]

    connect() {
        this.toggleSubmitButton()
    }

    toggleSubmitButton() {
        if (this.bodyTarget.value.trim() === "") {
            this.submitButtonTarget.disabled = true
            this.submitButtonTarget.classList.add("btn-disabled")
            this.submitButtonTarget.classList.remove("btn-primary")
        } else {
            this.submitButtonTarget.disabled = false
            this.submitButtonTarget.classList.remove("btn-disabled")
            this.submitButtonTarget.classList.add("btn-primary")
        }
    }
}