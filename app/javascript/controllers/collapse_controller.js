import { Controller } from "@hotwired/stimulus"
import { Collapse } from "bootstrap"

export default class extends Controller {
  connect() {
    this.collapse = new Collapse(this.element, {
      toggle: false,
    })
  }
}
