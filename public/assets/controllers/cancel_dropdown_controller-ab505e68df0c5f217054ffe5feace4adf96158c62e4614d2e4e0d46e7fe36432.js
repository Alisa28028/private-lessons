import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("✅ cancel-dropdown connected")
    this.menuTarget.style.display = "none"
    document.addEventListener("click", this.close.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.close.bind(this))
  }

  toggle(event) {
    event.stopPropagation() // ✅ prevent global click handler from closing it immediately
    this.menuTarget.style.display =
      this.menuTarget.style.display === "none" ? "block" : "none"
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.style.display = "none"
    }
  }
};
