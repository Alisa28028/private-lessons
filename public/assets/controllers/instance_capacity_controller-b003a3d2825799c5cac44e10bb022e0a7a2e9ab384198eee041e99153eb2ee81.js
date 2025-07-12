import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="instance-capacity"
export default class extends Controller {
  static targets = ["container", "instances"];


  connect() {
    console.log("InstanceCapacityController is connected!!");
  }

  toggle(event) {
    const container = this.containerTarget;
    container.style.display = event.target.checked ? "block" : "none";
  }
}
//   connect() {
//    console.log("CapacityController is connected!!")
//     this.instances = [];
//   }

//   toggle(event) {
//     if (event.target.checked) {
//       this.containerTarget.style.display = "block";
//       this.loadInstances();
//     } else {
//       this.containerTarget.style.display = "none";
//       this.instancesTarget.innerHTML = ""; // Clear when unchecked
//     }
//   }

//   loadInstances() {
//     // Fetch selected dates or instances from form
//     const selectedDates = JSON.parse(document.getElementById("selected-dates").dataset.dates || "[]");

//     // Clear before updating
//     this.instancesTarget.innerHTML = "";

//     if (selectedDates.length === 0) {
//       this.instancesTarget.innerHTML = "<p>No event instances available.</p>";
//       return;
//     }

//     // Generate capacity input fields dynamically
//     selectedDates.forEach((date, index) => {
//       const div = document.createElement("div");
//       div.classList.add("mb-2");
//       div.innerHTML = `
//         <label>Capacity for ${date}</label>
//         <input type="number" name="event[event_instances_attributes][${index}][capacity]" class="form-control" min="1">
//         <input type="hidden" name="event[event_instances_attributes][${index}][start_time]" value="${date}">
//       `;
//       this.instancesTarget.appendChild(div);
//     });
//   }
// };
