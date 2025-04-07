import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["photosPreview", "videosPreview", "photosInput", "videosInput"];

   // Store the original photo before uploading a new one
   originalPhoto = null;

  connect() {
    console.log("file preview controller connected!");
    this.originalPhoto = document.getElementById("current-photo").innerHTML;

  }
  // Show photo previews
  showPhotoPreviews(event) {
    const files = event.target.files;
    const currentPhotoDiv = document.getElementById("current-photo");

    // If there's an existing image, hide it
    if (currentPhotoDiv) {
      currentPhotoDiv.style.display = "none";
    }

    // Preview new photos
    this.photosPreviewTarget.innerHTML = ""; // Clear previous previews

    Array.from(files).forEach(file => {
      const reader = new FileReader();
      reader.onload = (e) => {
        // Create a new image element and set the source to the selected file
        const imgElement = document.createElement("img");
        imgElement.src = e.target.result;
        imgElement.style.width = "100px"; // Thumbnail size
        imgElement.style.marginRight = "10px"; // Spacing between images
        imgElement.style.objectFit = "cover"; // Ensure proper image scaling

        // Create the cancel button (cross) for the preview
        const cancelButton = document.createElement("span");
        cancelButton.innerText = "×";
        cancelButton.style.position = "absolute";
        cancelButton.style.top = "-12px";  // Adjust for circle placement
        cancelButton.style.right = "-12px";  // Adjust for circle placement
        cancelButton.style.fontSize = "20px";
        cancelButton.style.color = "white";
        cancelButton.style.cursor = "pointer";
        cancelButton.style.zIndex = "10"; // Ensure it's on top of the image
        cancelButton.style.width = "28px";  // Size of the circle
        cancelButton.style.height = "28px";  // Size of the circle
        cancelButton.style.borderRadius = "50%";  // Make it circular
        cancelButton.style.backgroundColor = "rgba(0, 0, 0, 0.6)";  // Semi-transparent black
        cancelButton.style.display = "flex";
        cancelButton.style.alignItems = "center";
        cancelButton.style.justifyContent = "center"; // Center the "X" inside the circle

        // Wrap the image and the cancel button in a container
        const previewContainer = document.createElement("div");
        previewContainer.style.position = "relative"; // To position the cancel button on top
        previewContainer.style.width = "100px"; // Match thumbnail size
        previewContainer.style.height = "auto"; // Allow image to maintain aspect ratio
        previewContainer.appendChild(imgElement);
        previewContainer.appendChild(cancelButton);

        // When the cancel button is clicked, revert to the original photo
        cancelButton.addEventListener("click", () => {
          // Restore the previous image and hide the preview container
          currentPhotoDiv.innerHTML = this.originalPhoto;
          currentPhotoDiv.style.display = "block"; // Show the original image again
          this.photosPreviewTarget.innerHTML = ""; // Clear the preview
        });

        // Append the new image with cancel button to the preview container
        this.photosPreviewTarget.appendChild(previewContainer);
      };
      reader.readAsDataURL(file);
    });
  }

  // Handle file input cancel
  handleFileInputCancel(event) {
    const files = event.target.files;
    const currentPhotoDiv = document.getElementById("current-photo");

    // If no files are selected (input was canceled), display the original photo
    if (files.length === 0) {
      currentPhotoDiv.style.display = "block"; // Show the original image again
      this.photosPreviewTarget.innerHTML = ""; // Clear any preview
    }
  }

  // Show video previews
  showVideoPreviews(event) {
    const files = event.target.files;
    this.videosPreviewTarget.innerHTML = ""; // Clear previous previews

    Array.from(files).forEach(file => {
      const reader = new FileReader();
      reader.onload = (e) => {
        const videoElement = document.createElement("video");
        videoElement.src = e.target.result;
        videoElement.controls = true;
        videoElement.style.width = "200px"; // Video thumbnail size
        videoElement.style.marginRight = "10px"; // Spacing between videos
        this.videosPreviewTarget.appendChild(videoElement);
      };
      reader.readAsDataURL(file);
    });
  }
}
