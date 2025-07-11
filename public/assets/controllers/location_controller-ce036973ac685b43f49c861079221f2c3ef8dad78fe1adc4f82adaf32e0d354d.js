import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "locationList", "newLocationForm", "newLocationInput", "saveLocationButton", "cancelButton", "locationSavedMessage"]

  connect() {
    console.log("location controller connected!");
    console.log("Location List Target:", this.locationListTarget);

    // If the location input already has a value (on page load), we can populate the list
    if (this.inputTarget.value.length > 0) {
      this.fetchLocationSuggestions(this.inputTarget.value);  // Fetch matching locations
    }
  }

  showUserLocations() {
    const locationsData = this.locationListTarget.dataset.locations;

    // Check if data-locations is defined and contains valid JSON
    let locations = [];
    if (locationsData) {
      try {
        locations = JSON.parse(locationsData);
        console.log("Locations data:", locations);
      } catch (e) {
        console.error("Invalid JSON in data-locations:", e);
      }
    } else {
      console.warn("No locations data available.");
    }

    // Clear the list before adding new items (optional)
    this.locationListTarget.innerHTML = '';  // Clear the previous list items

    // Populate the list with location names
    locations.forEach(location => {
      const li = document.createElement('li');
      li.textContent = location.name;  // Set the location name

      // Add hover effect (mouseenter and mouseleave)
      li.addEventListener('mouseenter', () => {
        li.style.backgroundColor = 'lightgray'; // Change color on hover
      });

      li.addEventListener('mouseleave', () => {
        li.style.backgroundColor = ''; // Reset color on mouse leave
      });

      // Add click event listener to each list item
      li.addEventListener('click', () => {
        console.log("Location item clicked:", location);  // Log location when clicked
        this.selectLocation(location);  // Call the method to select the location
      });

      // Append the list item to the location list
      this.locationListTarget.appendChild(li);
      console.log("Current HTML of location list:", this.locationListTarget.innerHTML);  // Log the current HTML
    });

    // Show the list by removing the 'd-none' class
    this.locationListTarget.classList.remove('d-none');
  }



  // Select location method to update the input and hidden fields
  selectLocation(location) {
    console.log("Location selected:", location);

    // Update the hidden input with the location ID
    const hiddenInput = document.querySelector('#event_location_id');
    hiddenInput.value = location.id;
    console.log("Updated hidden input value:", hiddenInput.value);

    // Update the visible input field with the location name
    this.inputTarget.value = location.name;
    console.log("Updated input value:", this.inputTarget.value);

    // Hide the list after selecting a location
    this.locationListTarget.classList.add('d-none');

    // Add the "selected" class to the clicked item
  const selectedLi = Array.from(this.locationListTarget.querySelectorAll('li')).find(li => li.textContent === location.name);
  if (selectedLi) {
    selectedLi.classList.add('selected');
  }

  // Optionally, reset other list items (deselect)
  Array.from(this.locationListTarget.querySelectorAll('li')).forEach(li => {
    if (li !== selectedLi) {
      li.classList.remove('selected');
    }
  });
  }

  // Method to save the new location
  saveLocation(event) {
    event.preventDefault();

    // Get the location name from the input field
    const locationName = this.newLocationFormTarget.querySelector('#new_location_name').value;

    // Send an AJAX request to create the location
    fetch('/locations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content, // Ensure CSRF token is included
      },
      body: JSON.stringify({ location: { name: locationName } })
    })
      .then(response => response.json())
      .then(data => {
        // Check if the response contains location_id and location_name
        if (data.location_id && data.location_name) {
          console.log("Location created:", data);

          // Find the select dropdown and create a new option
          const selectDropdown = this.inputTarget;  // This is the select element

          // Create a new option for the select dropdown with the new location name
          const newOption = document.createElement('option');
          newOption.value = data.location_id;  // Set the value to the new location's ID
          newOption.textContent = data.location_name;  // Set the text to the new location's name

          // Add the new option to the select dropdown
          selectDropdown.appendChild(newOption);

          // Set the newly created location as the selected option
          selectDropdown.value = data.location_id;

          // Hide the save and cancel buttons
          this.saveLocationButtonTarget.style.display = 'none';
          this.cancelButtonTarget.style.display = 'none';
          this.newLocationInputTarget.style.display = 'none';

          // Show the "Location Saved" message
          this.locationSavedMessageTarget.style.display = 'block';
        } else {
          console.error('Failed to save the location:', data);
        }
      })
      .catch(error => {
        console.error('Error saving location:', error);
      });
  }

  // Handle input change to filter location list
  updateLocationList(event) {
    const locationInput = event.target.value;

    if (locationInput.length > 0) {
      this.fetchLocationSuggestions(locationInput);
    } else {
      this.clearLocationList();
    }
  }

  // Fetch location suggestions from the server
  fetchLocationSuggestions(locationInput) {
    fetch(`/locations/search?query=${locationInput}`, {
      method: 'GET',
    })
      .then(response => response.json())
      .then(data => {
        this.populateLocationList(data);  // Populate the list with fetched data
      })
      .catch(error => {
        console.error("Error fetching locations:", error);
      });
  }

  // Populate the location list with fetched locations
  populateLocationList(locations) {
    const locationList = this.locationListTarget;
    locationList.innerHTML = '';  // Clear the list first

    console.log("Populating location list with locations:", locations);

    // Add each location as a list item
    locations.forEach(location => {
      const li = document.createElement('li');
      li.textContent = location.name;  // Set the location name as the text

      // Debugging: Check if each <li> element is being created
      console.log("Created <li> element for:", location.name);

      // Add the click event listener for each location
      li.addEventListener('click', () => {
        console.log("Location item clicked:", location);  // Should log when clicked
        this.selectLocation(location);
      });

      locationList.appendChild(li);  // Append to the list
    });

    // Remove 'd-none' to make the list visible
    locationList.classList.remove('d-none');
  }

  // Clear the location list and hide it
  clearLocationList() {
    this.locationListTarget.innerHTML = '';  // Clear the list
    this.locationListTarget.classList.add('d-none');  // Hide the list
  }

  // Handle blur event to hide the list when the user clicks outside
  handleBlur() {
    console.log("Blur event triggered!");
    // Delay hiding the list slightly
    setTimeout(() => {
        this.clearLocationList();
    }, 200);  // Adjust the delay (in milliseconds) as needed
}

// Show the form to create a new location
showNewLocationForm() {
  this.newLocationFormTarget.style.display = 'block';
// Show the save location button
this.saveLocationButtonTarget.style.display = 'inline-block'; // or 'block', depending on your layout
}

// Cancel new location creation (if the user wants to return to selecting an existing location)
cancelNewLocationForm() {
  this.newLocationFormTarget.style.display = 'none';  // Hide the new location form
  this.locationListTarget.classList.remove('d-none');  // Show the location suggestion list again
  }
};
