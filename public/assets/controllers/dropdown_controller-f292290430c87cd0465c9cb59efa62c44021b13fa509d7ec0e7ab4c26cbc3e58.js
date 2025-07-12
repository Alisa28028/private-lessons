import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown"];
  static values = { isOpen: Boolean };

  connect() {
    this.isOpenValue = false;
  }

  // Toggle dropdown visibility when the avatar is clicked
  toggle(event) {
    this.isOpenValue = !this.isOpenValue;
    this.updateDropdownVisibility();
    event.stopPropagation(); // Prevent click event from propagating
  }

  // Close the dropdown if clicked outside
  close() {
    this.isOpenValue = false;
    this.updateDropdownVisibility();
  }

  // Close the dropdown if click is outside the dropdown element
  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  // Update the dropdown visibility based on the current state (open/close)
  updateDropdownVisibility() {
    if (this.isOpenValue) {
      this.dropdownTarget.style.display = "block";
    } else {
      this.dropdownTarget.style.display = "none";
    }
  }

  // Prevent default link action, close dropdown, and navigate
  activateLink(event) {
    event.preventDefault(); // Prevent the default navigation behavior

    // Get the link URL and navigate after closing the dropdown
    const linkUrl = event.target.getAttribute("href");

    // Close the dropdown
    this.close();

    // Add active class to the clicked link
    const links = this.dropdownTarget.querySelectorAll("a");
    links.forEach(link => link.classList.remove("active-link"));
    event.target.classList.add("active-link");

    // Now, navigate to the selected URL
    setTimeout(() => {
      window.location.href = linkUrl;
    }, 100); // Slight delay to ensure dropdown closes before navigating
  }

  // Listen for clicks outside the dropdown to close it
  initialize() {
    document.addEventListener("click", this.closeOnClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside.bind(this));
  }
};
