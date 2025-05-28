import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["label"]

  updateLabel(event) {
    const checked = event.target.checked
    this.labelTarget.textContent = checked ? "YES" : "NO"
  }
}
