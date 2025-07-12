import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected")
  }
}

document.addEventListener("trix-initialize", (event) => {
  const editor = event.target;
  const toolbar = editor.toolbarElement;

  if (!toolbar) return;

  const group = toolbar.querySelector(".trix-button-group--text-tools");
  if (!group) return;

  // Prevent duplicate button
  if (group.querySelector("[data-trix-attribute='underline']")) return;

  const button = document.createElement("button");
  button.type = "button";
  button.className = "trix-button";
  button.setAttribute("data-trix-attribute", "underline");
  button.setAttribute("title", "Underline");
  button.setAttribute("tabindex", "-1");
  button.innerHTML = "<u>U</u>";

  group.appendChild(button);
});
