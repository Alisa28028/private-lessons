import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (window.bootstrap) {
      // Re-initialize collapse if necessary
      new bootstrap.Collapse(this.element, { toggle: false })
    }
  }
}
