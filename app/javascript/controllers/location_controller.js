import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "locationList"]

  connect() {
    // this.locations = ["Shinjuku Noah Studio 3", "Shibuya Studio A", "Roppongi Studio 5"]; // Example saved locations
    // this.filteredLocations = [];  // Initially empty
    console.log("location controller connected!")
  }


  updateLocationList(event) {
    const locationInput = event.target.value;

    if (locationInput.length > 0) {
      this.filterLocationList(locationInput);
    } else {
      this.clearLocationList();
    }
  }

  filterLocationList(locationInput) {
    const locationList = this.locationListTarget;
    const locations = JSON.parse(locationList.dataset.locations); // Load user locations dynamically
    const filteredLocations = locations.filter(location =>
      location.name.toLowerCase().includes(locationInput.toLowerCase())
    );

    locationList.innerHTML = filteredLocations.map(location =>
      `<li data-action="click->location#selectLocation" data-id="${location.id}">${location.name}</li>`
    ).join('');
    locationList.classList.remove('d-none');
  }

  clearLocationList() {
    this.locationListTarget.innerHTML = '';
    this.locationListTarget.classList.add('d-none');
  }

  selectLocation(event) {
    const selectedLocationId = event.target.dataset.id;
    const selectedLocationName = event.target.textContent;
    this.inputTarget.value = selectedLocationName;
    // Optionally, set the hidden input to the location ID
    const locationIdInput = document.querySelector('#event_location_id');
    locationIdInput.value = selectedLocationId;

    this.clearLocationList(); // Hide the list after selection
  }

  handleBlur() {
    this.clearLocationList();
    }


  saveLocation(locationInput) {
    if (locationInput) {
      fetch('/locations', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ location: { name: locationInput } }),
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
             // Set the hidden input value to the newly created location's ID
             const locationIdInput = document.querySelector('#event_location_id');
             locationIdInput.value = data.location.id;
           }
        });
    }
  }
}
