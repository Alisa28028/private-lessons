import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["checkbox", "label", "description", "section"]

  updateLabel() {
    const checked = this.checkboxTarget.checked
    this.labelTarget.textContent = checked ? "YES" : "NO"
    this.labelTarget.classList.toggle("switch-label--yes", checked)
    this.labelTarget.classList.toggle("switch-label--no", !checked)

    // Dynamic messages based on context (optional but flexible)
    const mode = this.checkboxTarget.dataset.mode // "approval" or "payment"

    if (this.hasDescriptionTarget) {
      if (mode === "approval") {
        this.descriptionTarget.textContent = checked
          ? "Students need your approval to book the class."
          : "Students can book the class directly."
      } else if (mode === "payment") {
        this.descriptionTarget.textContent = checked
          ? "Students must pay 100% at the time of booking. No cancellation refunds apply."
          : "Students will not be asked to pay immediately, and cancellation policies apply."
      }
    }

    if (this.hasSectionTarget) {
      this.sectionTarget.style.display = checked ? "none" : "block"
    }
  }
}
