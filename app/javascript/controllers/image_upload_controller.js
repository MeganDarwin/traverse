import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-upload"
export default class extends Controller {
  static targets = ["input", "button"];

  connect() {
    this.toggleButton();
  }

  toggleButton() {
    if (this.inputTarget.files.length > 0) {
      this.buttonTarget.disabled = false;
      this.buttonTarget.classList.remove("bg-gray-400", "cursor-not-allowed");
      this.buttonTarget.classList.add("bg-blue-600", "hover:bg-blue-500", "cursor-pointer");
    } else {
      this.buttonTarget.disabled = true;
      this.buttonTarget.classList.remove("bg-blue-600", "hover:bg-blue-500", "cursor-pointer");
      this.buttonTarget.classList.add("bg-gray-400", "cursor-not-allowed");
    }
  }
}