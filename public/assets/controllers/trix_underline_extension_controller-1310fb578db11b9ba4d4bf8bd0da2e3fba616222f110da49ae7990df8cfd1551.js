import { Controller } from "@hotwired/stimulus"
import "trix"

export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected")
  }
}

function setupUnderline() {
  const Trix = window.Trix

  if (!Trix.config.textAttributes.underline) {
    Trix.config.textAttributes.underline = {
      tagName: "u",
      inheritable: true,
      parser: (element) => element.tagName === "U"
    }
  }
}

// Run on initial load
setupUnderline()

// Run on every Turbo Frame load
document.addEventListener("turbo:frame-load", () => {
  setupUnderline()
});
