import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["label", "checkbox", "description"]

  updateLabel() {
    const isManual = this.checkboxTarget.checked
    this.labelTarget.textContent = isManual ? "YES" : "NO"
    this.labelTarget.classList.toggle("switch-label--yes", isManual)
    this.labelTarget.classList.toggle("switch-label--no", !isManual)

    // Update the description line
    this.descriptionTarget.textContent = isManual
      ? "Students need your approval to book the class."
      : "Students can book the class directly."
  }
}
