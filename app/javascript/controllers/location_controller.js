import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "locationList"]

  connect() {
    // this.locations = ["Shinjuku Noah Studio 3", "Shibuya Studio A", "Roppongi Studio 5"]; // Example saved locations
    // this.filteredLocations = [];  // Initially empty
    console.log("location controller connected!")
  }

  // When user focuses on the input, show the associated locations
  showUserLocations() {
    const locations = JSON.parse(this.locationListTarget.dataset.locations); // Get locations associated with the user
    console.log("User's Associated Locations: ", locations);

    this.populateLocationList(locations); // Populate the list with those locations
  }

  updateLocationList(event) {
    const locationInput = event.target.value;

    if (locationInput.length > 0) {
      this.fetchLocationSuggestions(locationInput);
    } else {
      this.clearLocationList();
    }
  }

  fetchLocationSuggestions(locationInput) {
    // Make an AJAX request to fetch locations matching the input
    fetch(`/locations/search?query=${locationInput}`, {
      method: 'GET',
    })
      .then(response => response.json())
      .then(data => {
        this.populateLocationList(data);
      })
      .catch(error => {
        console.error("Error fetching locations:", error);
      });
  }

  populateLocationList(locations) {
    const locationList = this.locationListTarget;
    // Clear any previous suggestions
    locationList.innerHTML = '';

    if (locations.length > 0) {
      locations.forEach(location => {
        locationList.innerHTML += `
          <li data-action="click->location#selectLocation" data-id="${location.id}">
            ${location.name}
          </li>
        `;
      });
      locationList.classList.remove('d-none');
    } else {
      locationList.classList.add('d-none'); // Hide if no matches
    }
  }


  clearLocationList() {
    this.locationListTarget.innerHTML = '';
    this.locationListTarget.classList.add('d-none');
  }

  // selectLocation(event) {
  //   const selectedLocationId = event.target.dataset.id;
  //   const selectedLocationName = event.target.textContent;
  //   this.inputTarget.value = selectedLocationName;
  //   // Optionally, set the hidden input to the location ID
  //   const locationIdInput = document.querySelector('#event_location_id');
  //   locationIdInput.value = selectedLocationId;

  //   this.clearLocationList(); // Hide the list after selection
  // }

  selectLocation(event) {
    const selectedLocation = event.target;
    const locationId = selectedLocation.getAttribute('data-id');
    const locationName = selectedLocation.textContent;

    // Set the location input value to the selected location name
    this.inputTarget.value = locationName;

    // Set the hidden location_id field value
    const locationIdInput = document.querySelector('#event_location_id');
    locationIdInput.value = locationId;

    // Hide the location list
    this.locationListTarget.classList.add('d-none');
  }

  handleBlur() {
    this.clearLocationList();
    }
}
