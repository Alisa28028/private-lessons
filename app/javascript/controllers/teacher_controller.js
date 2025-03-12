// import { Controller } from "@hotwired/stimulus"

// // Connects to data-controller="teacher"
// export default class extends Controller {
//   static targets = ["classes", "teacherPosts", "studentPosts"]  // Add studentPosts as a target

//   // Load the teacher's events (classes)
//   loadEvents(event) {
//     event.preventDefault()
//     fetch(`/users/${this.data.get("userId")}/classes`, {
//       headers: {
//         "Accept": "application/vnd.turbo-stream.html"
//       }
//     })
//     .then(response => response.text())
//     .then(html => {
//       this.contentTarget.innerHTML = html
//     })
//   }

//   // Load the teacher's posts
//   loadPosts(event) {
//     event.preventDefault()
//     fetch(`/users/${this.data.get("userId")}/teacher_posts`, {
//       headers: {
//         "Accept": "application/vnd.turbo-stream.html"
//       }
//     })
//     .then(response => response.text())
//     .then(html => {
//       this.contentTarget.innerHTML = html
//     })
//   }

//   // Load the student posts for this teacher
//   loadStudentPosts(event) {
//     event.preventDefault()
//     fetch(`/users/${this.data.get("userId")}/student_posts`, {
//       headers: {
//         "Accept": "application/vnd.turbo-stream.html"
//       }
//     })
//     .then(response => response.text())
//     .then(html => {
//       this.studentPostsTarget.innerHTML = html  // Populate the studentPosts target
//     })
//   }

//   // For full page reload
//   reloadPage(event) {
//     event.preventDefault()
//     window.location.href = event.target.href
//   }
// }


import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["content"];
  loadEvents(event) {
    event.preventDefault();
    this.loadContent(`/users/${this.data.get("userId")}/classes`);
  }

  loadPosts(event) {
    event.preventDefault();
    this.loadContent(`/users/${this.data.get("userId")}/teacher_posts`);
  }

  loadStudentPosts(event) {
    event.preventDefault();
    this.loadContent(`/users/${this.data.get("userId")}/student_posts`);
  }

  loadContent(url) {
    fetch(url, { headers: { "Accept": "text/html" } })
      .then((response) => response.text())
      .then((html) => {
        this.contentTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error loading content:", error));
  }
}
