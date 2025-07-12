import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  connect() {
    this.setupUnderline()
    this.element.addEventListener("trix-initialize", this.addUnderlineButton)
  }

  disconnect() {
    this.element.removeEventListener("trix-initialize", this.addUnderlineButton)
  }

  setupUnderline() {
    const Trix = window.Trix

    if (!Trix.config.textAttributes.underline) {
      Trix.config.textAttributes.underline = {
        tagName: "u",
        inheritable: true,
        parser: (element) => element.tagName === "U"
      }
    }
  }

  addUnderlineButton = (event) => {
    const editor = event.target
    const toolbar = editor.toolbarElement

    if (!toolbar) return

    const group = toolbar.querySelector(".trix-button-group--text-tools")
    if (!group) return

    if (group.querySelector("[data-trix-attribute='underline']")) return

    const button = document.createElement("button")
    button.type = "button"
    button.className = "trix-button"
    button.setAttribute("data-trix-attribute", "underline")
    button.setAttribute("title", "Underline")
    button.setAttribute("tabindex", "-1")
    button.innerHTML = "<u>U</u>"

    group.appendChild(button)
  }
}
