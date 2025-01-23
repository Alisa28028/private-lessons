import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-form"
export default class extends Controller {
  static targets = ["oneTimeEventForm", "recurringOptions", "everyWeekEventForm", "customRecurrence"];

  selectEventType(event) {
    const eventType = event.target.dataset.eventType;
    console.log(`Event Type Selected: ${eventType}`);

    this.oneTimeEventFormTarget.classList.add("d-none");
    this.recurringOptionsTarget.classList.add("d-none");

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

    this.everyWeekEventFormTarget.classList.add("d-none");
    this.customRecurrenceTarget.classList.add("d-none");

    if (recurrenceType === "every-week") {
      this.everyWeekEventFormTarget.classList.remove("d-none");
    } else if (recurrenceType === "custom-dates") {
      this.customRecurrenceTarget.classList.remove("d-none");
    }
  }
}
