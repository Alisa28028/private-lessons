import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = [
    "oneTimeEventForm",
    "recurringEventForm",
    "eventDate"
    // "recurringOptions",
    // "customRecurrence",
    // "eventInstances",
    // "list",
    // "locationList"
  ];

  connect() {
    console.log("datepicker controller connected!");

  // initialize flatpickr on the date input field
    flatpickr(this.eventDateTarget, {
      dateFormat: "Y-m-d",
      minDate: "today",
      enableTime: false,
    });
  }

  selectEventType(event) {
    const eventType = event.target.dataset.eventType;
    console.log(`Event Type Selected: ${eventType}`);

    // Hide both forms by default
    this.oneTimeEventFormTarget.classList.add("d-none");
    this.recurringEventFormTarget.classList.add("d-none");

    if (eventType === "One-time") {
      console.log("Showing one-time event form.");
      this.oneTimeEventFormTarget.classList.remove("d-none");
    } else if (eventType === "recurring") {
      console.log("Showing recurring event form.");
      this.recurringEventFormTarget.classList.remove("d-none");
    }
  }

  selectRecurrence(event) {
    const recurrenceType = event.target.dataset.eventType;
    console.log(`Recurrence Type Selected: ${recurrenceType}`);

    if (recurrenceType === "custom-dates") {
      this.customRecurrenceTarget.classList.remove("d-none");
    } else {
      this.customRecurrenceTarget.classList.add("d-none");
    }
  }


  fetchStudios() {
    const url = `${location.pathname}?start_time=${this.startTarget.value}&end_time=${this.endTarget.value}`
    fetch(url)
      .then(response=>response.text())
      .then(data => {
        // console.log(data)
        this.listTarget.innerHTML = data
        const studioNames = this.listTarget.querySelectorAll(".studio-name")
        studioNames.forEach(studio=>{
          const name = studio.innerText
          this.locationListTarget.insertAdjacentHTML("beforeend", `<option value="${name}">${name}</option>`)
        })
        const studioCards = this.listTarget.querySelectorAll(".studio-card")
        studioCards.forEach(card=>{
          card.addEventListener("click", (event) => {
            const name = event.currentTarget.querySelector(".studio-name").innerText
            this.locationListTarget.value = name
            this.locationListTarget.name = "location_name"
          })
        })
      })
  }
}
