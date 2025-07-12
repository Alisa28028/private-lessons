import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["content"];


  connect() {
    if (window.location.hash === "#posts-tab") {
      this.setSelectedTab("posts-tab-link");
      this.loadPosts();
    }
  }

  loadEvents(event) {
    event?.preventDefault();
    this.setSelectedTab("events-tab-link");
    this.loadContent(`/users/${this.data.get("userId")}/classes`);
  }

  loadPosts(event) {
    event?.preventDefault();
    this.setSelectedTab("posts-tab-link");
    this.loadContent(`/users/${this.data.get("userId")}/teacher_posts`);
  }

  loadStudentPosts(event) {
    event?.preventDefault();
    this.setSelectedTab("student-posts-tab-link");
    this.loadContent(`/users/${this.data.get("userId")}/student_posts`);
  }

  setSelectedTab(selectedId) {
    document.querySelectorAll(".icon-tab").forEach(link => {
      link.classList.remove("selected");
    });

    const selectedTab = document.getElementById(selectedId);
    selectedTab?.classList.add("selected");
  }

  loadContent(url) {
    fetch(url, { headers: { "Accept": "text/html" } })
      .then((response) => response.text())
      .then((html) => {
        this.contentTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error loading content:", error));
  }
};
