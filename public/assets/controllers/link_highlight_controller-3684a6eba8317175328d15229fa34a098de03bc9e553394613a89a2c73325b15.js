import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="link-highlight"
export default class extends Controller {
  static targets = ["link"];

  connect() {
    // set the default selected link on page load
    this.setDefaultLink();

    // Add event listeners to the links
    this.links.forEach(link => {
      link.addEventListener('click', () => this.highlightLink(link));
    });
  }

// Highlight the clicked link and remore 'selected' class from others
  highlightLink(link) {
    this.links.forEach(link => link.classList.remove('selected'));
    link.classList.add('selected');
  }

  // Set the defualt link as selected when the page loads
  setDefaultLink() {
    const defaultLink = this.links[0]; // Default is the first link (classes)
    if (defaultLink) {
      defaultLink.classList.add('selected');
    }
  }

  get links() {
    return this.element.querySelectorAll('a'); // get all liunks inside the controler's element
 }
};
