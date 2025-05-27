// does not working so currently not in use.

import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  connect() {
    // Always destroy old instance if it exists
    const existing = window.bootstrap.Offcanvas.getInstance(this.element)
    if (existing) {
      existing.dispose()
    }

    // Create a fresh instance
    this.offcanvas = window.bootstrap.Offcanvas.getOrCreateInstance(this.element)
    console.log("Offcanvas ready", this.offcanvas)
  }

  hide() {
    this.offcanvas?.hide()

  }
}
