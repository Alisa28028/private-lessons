import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-form"
export default class extends Controller {
  static targets = ["oneTimeEventForm", "recurringOptions", "everyWeekEventForm", "customRecurrence"];

  connect() {
    // Automatically detect and set the user's time zone
    this.setUserTimeZone();
  }

  setUserTimeZone() {
    const tzInput = document.getElementById('user-time-zone');
    if (tzInput && typeof Intl !== "undefined") {
      // Set the time zone value to the hidden field
      tzInput.value = Intl.DateTimeFormat().resolvedOptions().timeZone;
    }
  }

  selectEventType(event) {
    const eventType = event.target.dataset.eventType;
    console.log(`Event Type Selected: ${eventType}`);

    // Reset button styles for all event type buttons
  document.querySelectorAll('[data-event-type]').forEach(button => {
    button.classList.remove("btn-primary");
    button.classList.add("btn-outline-primary");
  });

  // Highlight the selected button
  event.target.classList.remove("btn-outline-primary");
  event.target.classList.add("btn-primary");

    // hide all forms initially
    this.oneTimeEventFormTarget.classList.add("d-none");
    this.recurringOptionsTarget.classList.add("d-none");
    this.everyWeekEventFormTarget.classList.add("d-none")
    this.customRecurrenceTarget.classList.add("d-none");

    // show selected form
    if (eventType === "One-time") {
      console.log("Showing one-time event form.");
      this.oneTimeEventFormTarget.classList.remove("d-none");
    } else if (eventType === "recurring") {
      console.log("Showing recurring options.");
      this.recurringOptionsTarget.classList.remove("d-none");
    }
  }

  selectRecurrence(event) {
    const recurrenceType = event.target.dataset.recurrenceType;
    console.log(`Recurrence Type Selected: ${recurrenceType}`);


    // set the value of the hidden recurrence_type field
    const recurrenceField = document.getElementById("recurrence_type");
    if (recurrenceField) {
      recurrenceField.value = recurrenceType;
    }

       // Reset button styles for all recurring event options buttons
  document.querySelectorAll('[data-recurrence-type]').forEach(button => {
    button.classList.remove("btn-primary");
    button.classList.add("btn-outline-primary");
  });

  // Highlight the selected button
  event.target.classList.remove("btn-outline-primary");
  event.target.classList.add("btn-primary");

    // hide both forms
    this.everyWeekEventFormTarget.classList.add("d-none");
    this.customRecurrenceTarget.classList.add("d-none");

    // show selected form
    if (recurrenceType === "every-week") {
      this.everyWeekEventFormTarget.classList.remove("d-none");
      this.customRecurrenceTarget.classList.add("d-none");
    } else if (recurrenceType === "custom-dates") {
      this.customRecurrenceTarget.classList.remove("d-none");
    }
  }
}
