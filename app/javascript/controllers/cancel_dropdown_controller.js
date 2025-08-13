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
    console.log("🔥 Toggle clicked!", this.menuTarget.style.display)
    event.stopPropagation()
    this.menuTarget.style.display =
      this.menuTarget.style.display === "none" ? "block" : "none"

    if (this.menuTarget.style.display === "block") {
      const rect = this.menuTarget.getBoundingClientRect()
      console.log("🔥 Dropdown position:", {
        top: rect.top,
        left: rect.left,
        width: rect.width,
        height: rect.height,
        visible: rect.top >= 0 && rect.left >= 0
      })
    }
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.style.display = "none"
    }
  }
}
