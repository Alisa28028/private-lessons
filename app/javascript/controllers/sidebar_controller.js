import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "content", "hamburger"];

  connect() {
    this.updateSidebarState();
    window.addEventListener("resize", () => this.updateSidebarState());
  }

  updateSidebarState() {
    const width = window.innerWidth;

    // Show/hide sidebar based on screen width
    if (width >= 1000 && width <= 1619) {
      this.sidebarTarget.classList.add("show");
      this.contentTarget.classList.add("show-sidebar");
    } else {
      this.sidebarTarget.classList.remove("show");
      this.contentTarget.classList.remove("show-sidebar");
    }

    // Hide hamburger if sidebar is visible
    if (this.sidebarTarget.classList.contains("show")) {
      this.hamburgerTarget.style.display = "none";
    } else {
      this.hamburgerTarget.style.display = "block";
    }
  }
}
