import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = [
    "start",
    "end",
    "list",
    "locationList",
    "recurrenceSelect",
    "customRecurrenceField",
    "customDatesInput",
    "TimeInput"
  ];

  connect() {
    this.initStartDatePicker();
    this.initEndDatePicker();

    // Listen for changes in recurrence pattern selection
    this.recurrenceSelectTarget.addEventListener("change", this.toggleCustomRecurrenceField.bind(this));


    // Show custom recurrence field if "Custom Dates" is selected
    if (this.recurrenceSelectTarget.value === "Custom Dates") {
      this.customRecurrenceFieldTarget.classList.remove("d-none")
      this.initFlatpickrForCustomDates()
    }
  }

  // Initialize the start date picker
  initStartDatePicker() {
    flatpickr(this.startTarget, {
      enableTime: true,           // Enable time picker
      dateFormat: "Y-m-d H:i",    // Date and time format
      disableMobile: "true",
      onChange: this.setEndDate.bind(this), // Set end date based on start date
    });
  }

  // Initialize the end date picker
  initEndDatePicker() {
    flatpickr(this.endTarget, {
      enableTime: true,           // Enable time picker
      dateFormat: "Y-m-d H:i",    // Date and time format
      disableMobile: "true",
    });
  }

  // Set the end date based on the selected start date
  setEndDate(selectedDates) {
    if (selectedDates.length > 0) {
      const selectedDate = selectedDates[0];
      selectedDate.setMinutes(selectedDate.getMinutes() + 60); // Add 60 minutes
      this.endTarget._flatpickr.setDate(selectedDate);
    }
  }

  // Toggle custom recurrence field based on the recurrence type selected
  toggleCustomRecurrenceField(event) {
    const recurrenceType = event.target.value
    if (recurrenceType === "Custom Dates") {
      this.customRecurrenceField.classList.remove("d-none")
      this.initFlatpickrForCustomDates()
  } else {
    // Hide the custom recurrence input
    this.customRecurrenceField.classList.add("d-none")
  }
}

  // Initialize Flatpickr for custom date selection
  initFlatpickrForCustomDates() {
    flatpickr(this.customDatesInputTarget, {
      mode: "multiple", // allow multiple date selection
      dateFormat: "Y-m-d", // Date format output
      disableMobile: true,
      onChange: this.updateCustomDatesInput.bind(this),
    });
  }

  // Update the custom dates input with the selected dates
  updateCustomDatesInput(selectedDates) {
    // First, get the time from the input field
  const selectedTime = this.timeInputTarget.value;

  // If the time is not selected, we should notify the user
  if (!selectedTime) {
    alert("Please select a time for your recurring events.");
    return;
  }

  const [hours, minutes] = selectedTime.split(":").map(num => parseInt(num))

  // Now combine the selected time with each of the custom selected dates
  const dateStrings = selectedDates.map(date => {
    // Set the time (hours, minutes) for each date
    date.setHours(hours, minutes, 0, 0);

    // Return the formatted date with the combined time (ISO format)
    return date.toISOString(); // we return the full date-time, not just the date part
  });

  // Set the formatted date strings in the custom input field
  this.customDatesInputTarget.value = dateStrings.join(","); // Join the dates with commas
}

  // Fetch available studios (existing logic)
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
