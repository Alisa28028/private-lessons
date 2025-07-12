import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const modals = document.querySelectorAll(".modal");
    modals.forEach(function (modal) {
      new bootstrap.Modal(modal);
    });
  }

  handleClick(event) {
    event.preventDefault();
    event.stopPropagation();
  }
};
