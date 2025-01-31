import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = [
    "eventDate",
    "eventTime",
    "recurrenceType",
    "weeklyDatePicker",
    "customDatePicker",
    // "eventInstances",
    // "list",
    // "locationList"
  ];



  connect() {
    console.log("datepicker controller connected!");
    this.initTimePicker();


  //   // listen for custom events
  //   this.element.addEventListener("recurrenceTypeChanged", (event) => {
  //     console.log("Recurrence type changed event fired!", event); // Ensure the event is firing

  //     const { recurrenceType } = event.detail;
  //     console.log(`Recurrence type changed to : ${recurrenceType}`);
  //     this.handleRecurrenceChange(recurrenceType);
  //   });
  // }

  /// Listen for recurrence type changes (button clicks)
  const recurrenceButtons = document.querySelectorAll('[data-recurrence-type]');

  recurrenceButtons.forEach(button => {
    button.addEventListener("click", (event) => {
      const recurrenceType = event.target.dataset.recurrenceType;
      console.log(`Recurrence Type Selected: ${recurrenceType}`);

      this.handleRecurrenceChange(recurrenceType);
    });
  });
}


  handleRecurrenceChange(recurrenceType) {
    console.log("Recurrence type changed to:", recurrenceType);

    // Destroy existing Flatpickr instance if it exists
    if (this.datePickerInstance) {
      this.datePickerInstance.destroy();
      this.datePickerInstance = null;
    }

    const checkTargetAndInitialize = () => {
      if (recurrenceType === "one-time") {
        console.log("📅 Initializing Flatpickr with single mode!");
        const eventDateInput = document.querySelector("[data-datepicker-target='eventDate']");
        if (eventDateInput) {
          this.initFlatpickrSingle(eventDateInput);
        } else {
          console.warn("⏳ Waiting for eventDate input to appear...");
          setTimeout(checkTargetAndInitialize, 50);
        }
      } else if (recurrenceType === "every-week") {
        console.log("📅 Initializing Flatpickr with range mode");
        const weeklyPickerInput = document.querySelector("[data-datepicker-target='weeklyDatePicker']");
        if (weeklyPickerInput) {
          this.initFlatpickrRange(weeklyPickerInput);
        } else {
          console.warn("⏳ Waiting for weeklyDatePicker input to appear...");
          setTimeout(checkTargetAndInitialize, 50);
        }
      } else if (recurrenceType === "custom-dates") {
        console.log("📅 Initializing Flatpickr with multiple mode");
        const customPickerInput = document.querySelector("[data-datepicker-target='customDatePicker']");
        if (customPickerInput) {
          this.initFlatpickrMultiple(customPickerInput);
        } else {
          console.warn("⏳ Waiting for customDatePicker input to appear...");
          setTimeout(checkTargetAndInitialize, 50);
        }
      }
    };

    // Start checking for target availability
    setTimeout(checkTargetAndInitialize, 50);
  }


  initFlatpickrSingle(target) {
    const flatpickrOptions = {
      dateFormat: "Y-m-d",
      minDate: "today",
      mode: "single",
      onchange: this.updateHiddenFields.bind(this),
    };

    console.log("initializing flatpickr with single mode");
    this.initializeFlatpickr(target, flatpickrOptions);
  }

  initFlatpickrRange(target) {
    const flatpickrOptions = {
      dateFormat: "Y-m-d",
      minDate: "today",
      mode: "range",
      onChange: this.updateHiddenFields.bind(this),
    };

    console.log("initializing flatpickr with range mode");
    this.initializeFlatpickr(target, flatpickrOptions);
  }

  initFlatpickrMultiple(target) {
    const flatpickrOptions = {
      dateFormat: "Y-m-d",
      minDate: "today",
      mode: "multiple",
      onChange: this.updateHiddenFields.bind(this),
    };
    console.log("initializing flatpickr with multiple mode");
    this.initializeFlatpickr(target, flatpickrOptions);
  }

  initializeFlatpickr(target, options) {
    if (!target) {
      console.error("flatpickr target is undefined or null!");
      return;
    }

    // destroy previous instance if it exists
    if (this.datePickerInstance) {
      this.datePickerInstance.destroy();
    }
    this.datePickerInstance = flatpickr(target, options);
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
    if (this.hasWeeklyDatePickerTarget) {
      // Handling weekly event date range
    const startDate = selectedDates[0] ? selectedDates[0].toISOString().split("T")[0] : "";
    const endDate = selectedDates[1] ? selectedDates[1].toISOString().split("T")[0] : "";

    document.getElementById("event_start_date").value = startDate;
    document.getElementById("event_end_date").value = endDate;
  }

  if (this.hasCustomDatePickerTarget) {
    // Handling custom dates (multiple selections)
    const formattedDates = selectedDates.map(date => date.toISOString().split("T")[0]);
    console.log("Selected custom dates:", formattedDates);

    const customDatesField = document.getElementById("custom_dates_field");
    if (customDatesField) {
      customDatesField.value = formattedDates.join(","); // Store as a comma-separated string
    } else {
      console.error("Custom dates field not found in form!");
    }
  }
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
