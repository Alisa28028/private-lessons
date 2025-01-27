import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = [
    "eventDate",
    "eventTime",
    "recurrenceType"
    // "eventInstances",
    // "list",
    // "locationList"
  ];

  connect() {
    console.log("datepicker controller connected!");
    this.initFlatpickr();
    this.initTimePicker();

    // listen for custom events
    this.element.addEventListener("recurrenceTypeChanged", (event) => {
      console.log("Recurrence type changed event fired!", event); // Ensure the event is firing

      const { recurrenceType } = event.detail;
      console.log(`Recurrence type changed to : ${recurrenceType}`);
      this.handleRecurrenceChange(recurrenceType);
    });
  }

  initFlatpickr(mode = "range") {
    const flatpickrOptions = {
      dateFormat: "Y-m-d",
      minDate: "today",
      mode: mode, // Use the mode passed as a parameter
      onChange: this.updateHiddenFields.bind(this),
    };

    console.log(`Initializing Flatpickr with mode: ${mode}`, flatpickrOptions);

    // Initialize flatpickr with the options
    this.datePickerInstance = flatpickr(this.eventDateTarget, flatpickrOptions);
  }

  initFlatpickrRange(mode = "range") {
    const flatpickrOptions = {
      dateFormat: "Y-m-d",
      minDate: "today",
      mode: mode, // Use the mode passed as a parameter
      onChange: this.updateHiddenFields.bind(this),
    };

    console.log(`it should work Initializing Flatpickr with mode: ${mode}`, flatpickrOptions);

    // Initialize flatpickr with the options
    this.datePickerInstance = flatpickr(this.eventDateTarget, flatpickrOptions);
  }


  handleRecurrenceChange(recurrenceType) {
    console.log("Recurrence type changed to:", recurrenceType);

    // Destroy existing Flatpickr instance if it exists
    if (this.datePickerInstance) {
      this.datePickerInstance.destroy();
    }

    // Initialize the Flatpickr instance with the appropriate mode
    if (recurrenceType === "every-week") {
      console.log("Initializing Flatpickr with range mode");
      this.initFlatpickrRange("range");
    } else {
      console.log("Initializing Flatpickr with single mode");
      this.initFlatpickr("single");
    }
  }



  initTimePicker() {
    // Initialize Flatpickr for time input (single time picker)
    flatpickr(this.eventTimeTarget, {
      enableTime: true,
      noCalendar: true,
      dateFormat: "H:i",
      onChange: this.updateTimeHiddenField.bind(this),
    });
  }

  updateHiddenFields(selectedDates) {
    const startDate = selectedDates[0] ? selectedDates[0].toISOString().split("T")[0] : "";
    const endDate = selectedDates[1] ? selectedDates[1].toISOString().split("T")[0] : "";

    document.getElementById("event_start_date").value = startDate;
    document.getElementById("event_end_date").value = endDate;
  }

  updateTimeHiddenField(selectedDates) {
    const selectedTime = selectedDates[0] ? selectedDates[0].toTimeString().split(" ")[0] : "";
    document.getElementById("hidden_event_start_time").value = selectedTime;
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
