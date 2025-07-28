import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["checkbox", "label", "description", "section"]
  static values = { teacherUrl: String, studentUrl: String }

  updateLabel() {
    const checked = this.checkboxTarget.checked
    const mode = this.checkboxTarget.dataset.mode // e.g., "approval", "payment"

    // Localized label text
    const yesText = this.checkboxTarget.dataset.yesLabel || "YES"
    const noText = this.checkboxTarget.dataset.noLabel || "NO"
    this.labelTarget.textContent = checked ? yesText : noText

    this.labelTarget.classList.toggle("switch-label--yes", checked)
    this.labelTarget.classList.toggle("switch-label--no", !checked)

    // Localized description
    if (this.hasDescriptionTarget) {
      if (mode === "approval") {
        const approvalOn = this.checkboxTarget.dataset.approvalOn || "Students need your approval to book the class."
        const approvalOff = this.checkboxTarget.dataset.approvalOff || "Students can book the class directly."
        this.descriptionTarget.textContent = checked ? approvalOn : approvalOff
      } else if (mode === "payment") {
        const paymentOn = this.checkboxTarget.dataset.paymentOn || "Students must pay 100% at the time of booking. No cancellation refunds apply."
        const paymentOff = this.checkboxTarget.dataset.paymentOff || "Students will not be asked to pay immediately, and cancellation policies apply."
        this.descriptionTarget.textContent = checked ? paymentOn : paymentOff
      }
    }

    // Optional section visibility
    if (this.hasSectionTarget) {
      this.sectionTarget.style.display = checked ? "none" : "block"
    }
  }

  switchView() {
    const isTeacher = this.checkboxTarget.checked
    const newLabel = isTeacher ? "TEACHER" : "STUDENT"
    this.labelTarget.textContent = newLabel
    this.labelTarget.classList.toggle("switch-label--yes", isTeacher)
    this.labelTarget.classList.toggle("switch-label--no", !isTeacher)

    const url = isTeacher ? this.teacherUrlValue : this.studentUrlValue
    Turbo.visit(url)
  }
}
