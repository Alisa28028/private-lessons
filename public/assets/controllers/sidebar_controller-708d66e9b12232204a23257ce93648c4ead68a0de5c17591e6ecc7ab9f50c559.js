import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["sidebar", "content"];

  connect() {
    // Initially, check screen width and decide if sidebar should be visible
    this.toggleSidebar();
    window.addEventListener("resize", () => this.toggleSidebar());
  }

  toggleSidebar() {
    const width = window.innerWidth;

    if (width >= 1000 && width <= 1619) {
      // Show sidebar and hide navbars
      this.sidebarTarget.classList.add("show");
      this.contentTarget.classList.add("show-sidebar");
    } else {
      // Hide sidebar and reset content margin
      this.sidebarTarget.classList.remove("show");
      this.contentTarget.classList.remove("show-sidebar");
    }
  }
};
