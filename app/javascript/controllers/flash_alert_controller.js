import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash-alert"
export default class extends Controller {
  static targets = ["alert"]

  connect() {
    setTimeout(() => {
      this.fadeOut();
    }, 3000);
  }

  fadeOut() {
    this.alertTarget.classList.add("fade");
    setTimeout(() => {
      this.alertTarget.remove();
    }, 800);
  }
}
