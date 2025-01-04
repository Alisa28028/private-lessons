import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="teacher"
export default class extends Controller {
  static targets = ["content"]

  // load the teacher's events (classes)
  loadEvents(event) {
    event.preventDefault()
    fetch(`/users/${this.data.get("userId")}/classes`, {
      headers: {
        "Accept": "application/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text ())
    .then(html => {
      this.contentTarget.innerHTML = html
    })
  }

    // load the teacher's posts
    loadPosts(event) {
      event.preventDefault()
      fetch(`/users/${this.data.get("userId")}/teacher_posts`, {
        headers: {
          "Accept": "application/vnd.turbo-stream.html"
        }
      })
      .then(response => response.text())
      .then(html => {
        this.contentTarget.innerHTML = html
      })
    }
// Load the student posts for this teacher
loadStudentPosts(event) {
  event.preventDefault()
  fetch(`/users/${this.data.get("userId")}/student_posts`, {
    headers: {
      "Accept": "application/vnd.turbo-stream.html"
    }
  })
  .then(response => response.text())
  .then(html => {
    this.contentTarget.innerHTML = html
  })
}
}
