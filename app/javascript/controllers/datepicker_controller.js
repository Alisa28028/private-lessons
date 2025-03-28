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
    "locationInput",
    "locationList",
    "saveLocationBtn",
    "list"
    // "locationList"
  ];



  connect() {
    console.log("datepicker controller connected!");
    this.initTimePicker();

    // Listen for location input changes (and save if needed)
    this.locationInputTarget.addEventListener("input", this.handleLocationInput.bind(this));
    this.saveLocationBtnTarget.addEventListener("click", this.saveLocation.bind(this));

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

  handleLocationInput() {
    const locationInputValue = this.locationInputTarget.value.trim();
    const locationList = this.locationListTarget;

    if (locationInputValue) {
      // Show the save button if the location input has value
      this.saveLocationBtnTarget.style.display = "inline-block";
    } else {
      // Hide the save button if the location input is empty
      this.saveLocationBtnTarget.style.display = "none";
    }

    // Update location list if there are existing saved locations (from the database or session)
    locationList.innerHTML = ""; // Clear list before repopulating
    this.fetchSavedLocations(); // You can implement this method to fetch from the database or wherever you're storing the locations
  }

  saveLocation(event) {
    event.preventDefault();
    const locationInputValue = this.locationInputTarget.value.trim();

    if (locationInputValue) {
      // Add the location to the list of saved locations
      const newLocation = document.createElement("option");
      newLocation.textContent = locationInputValue;
      this.locationListTarget.appendChild(newLocation);

      // Optionally save to the database via AJAX or by adding a hidden field with the new location value
      console.log(`Location saved: ${locationInputValue}`);

      // Optionally clear the input after saving
      this.locationInputTarget.value = "";
      this.saveLocationBtnTarget.style.display = "none";  // Hide save button
    }
  }

  fetchSavedLocations() {
    // This method can fetch saved locations from the server or database if applicable
    // For now, it's just a placeholder to indicate where saved locations could be added to the list
    const savedLocations = ["Location 1", "Location 2", "Location 3"]; // Example list of saved locations
    savedLocations.forEach(location => {
      const option = document.createElement("option");
      option.textContent = location;
      this.locationListTarget.appendChild(option);
    });
  }


handleRecurrenceChange(recurrenceType) {
  console.log("Recurrence type changed to:", recurrenceType);

  // Destroy existing Flatpickr instance if it exists
  if (this.datePickerInstance) {
    this.datePickerInstance.destroy();
    this.datePickerInstance = null;
  }

  // Target element initialization
  const checkTargetAndInitialize = () => {
    let targetElement;

    if (recurrenceType === "one-time") {
      console.log("📅 Initializing Flatpickr with single mode!");
      targetElement = document.querySelector("[data-datepicker-target='eventDate']");
    } else if (recurrenceType === "every-week") {
      console.log("📅 Initializing Flatpickr with range mode");
      targetElement = document.querySelector("[data-datepicker-target='weeklyDatePicker']");
    } else if (recurrenceType === "custom-dates") {
      console.log("📅 Initializing Flatpickr with multiple mode");
      targetElement = document.querySelector("[data-datepicker-target='customDatePicker']");
    }

    if (targetElement) {
      this.initFlatpickrSingle(targetElement);  // Or appropriate flatpickr initialization based on mode
    } else {
      console.warn("⏳ Waiting for datepicker input to appear...");
      setTimeout(checkTargetAndInitialize, 200);  // Delay to avoid excessive retries
    }
  };

  // Start checking for target availability
  checkTargetAndInitialize();
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
      onClose: (selectedDates) => {
        if (selectedDates.length === 2) {
             // Convert to JST and get YYYY-MM-DD format
          const formatDate = (date) => {
            return new Date(date.getTime() - date.getTimezoneOffset() * 60000)
              .toISOString()
              .split("T")[0];
          };

          const startDate = formatDate(selectedDates[0]);
          const endDate = formatDate(selectedDates[1]);
          console.log("📅 Weekly Event - Start Date:", startDate, "End Date:", endDate);

          document.getElementById("event_start_date").value = startDate;
          document.getElementById("event_end_date").value = endDate;
        } else {
          console.warn("⚠️ Please select a valid date range.");
        }
      },
    };

    console.log("📅 Initializing Flatpickr with range mode");
    this.initializeFlatpickr(target, flatpickrOptions);
  }


  initFlatpickrMultiple(target) {
    const flatpickrOptions = {
      dateFormat: "Y-m-d",
      timeZone: 'Asia/Tokyo',
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
    const formattedDates = selectedDates.map(date => {
      // Adjusting for the local timezone by subtracting the offset
      return new Date(date.getTime() - date.getTimezoneOffset() * 60000)
        .toISOString()
        .split("T")[0];  // Get only the "YYYY-MM-DD" part
    });
    console.log("Selected custom dates:", formattedDates);

    // 🔥 Actually update the hidden input field here!
    const customDatesField = document.getElementById("custom_dates_field");
    if (customDatesField) {
      customDatesField.value = JSON.stringify(formattedDates);
    } else {
      console.error("❌ custom_dates_field not found in the DOM!");
    }
  }
}

  updateTimeHiddenField(selectedDates) {
    if (!selectedDates.length) return; // Prevent errors if no dates are selected

    const selectedTime = selectedDates[0] ? selectedDates[0].toTimeString().split(" ")[0] : "";
    const applySameTimeToAll = document.getElementById("apply_same_time_to_all")?.checked;

    let timeValues;

    if (applySameTimeToAll) {
      // Apply the same time to all selected dates
      timeValues = new Array(selectedDates.length).fill(selectedTime);
    } else {
      // Use the selected time for each custom date
      timeValues = selectedDates.map(date => date.toTimeString().split(" ")[0]);
    }

    console.log("⏰ Final time values:", timeValues);

    // Update hidden fields based on event type
    if (this.hasWeeklyDatePickerTarget) {
      document.getElementById("hidden_weekly_event_start_time").value = timeValues.join(",");
    }

    if (this.hasCustomDatePickerTarget) {
      document.getElementById("hidden_custom_event_start_time").value = timeValues.join(",");
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
