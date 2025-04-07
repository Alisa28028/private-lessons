import { Controller } from "@hotwired/stimulus"

import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = ["dateForm", "timeForm", "dateInput", "timeInput"];

  connect() {
    console.log("edit-form controller connected!");
    // this.initializeDatepickr();
    // this.initializeTimepickr();
  }
// Toggle the date edit form visibility
toggleDateForm(event) {
  event.preventDefault();
  this.dateFormTarget.style.display = this.dateFormTarget.style.display === "none" ? "block" : "none";
  this.timeFormTarget.style.display = "none"; // Hide the time form
  this.initializeDatepicker(); // Initialize date picker when shown
}

// Toggle the time edit form visibility
toggleTimeForm(event) {
  event.preventDefault();
  this.timeFormTarget.style.display = this.timeFormTarget.style.display === "none" ? "block" : "none";
  this.dateFormTarget.style.display = "none"; // Hide the date form
  this.initializeTimepicker(); // Initialize time picker when shown
}

initializeDatepicker() {
  if (this.dateInputTarget && !this.dateInputTarget._flatpickr) {
    // Check if it's a date input before initializing flatpickr
    if (this.dateInputTarget.type === "text") {
      flatpickr(this.dateInputTarget, {
        dateFormat: "Y-m-d",
        minDate: "today", // Disable past dates
      });
    }
  }
}

initializeTimepicker() {
  if (this.timeInputTarget && !this.timeInputTarget._flatpickr) {
    // Check if it's a time input before initializing flatpickr
    if (this.timeInputTarget.type === "time") {
      flatpickr(this.timeInputTarget, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
      });
    }
  }
}
}
