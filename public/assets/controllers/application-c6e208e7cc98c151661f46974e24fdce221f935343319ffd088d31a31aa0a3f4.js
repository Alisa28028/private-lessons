// Import Turbo (so Turbo frames and Turbo streams can work)
import { Turbo } from "@hotwired/turbo-rails"

// Import Stimulus (for managing front-end interactivity)
import { Application } from "@hotwired/stimulus"
const application = Application.start()

// Configure Stimulus development experience (optional for production)
application.debug = false
window.Stimulus = application

// Export the Stimulus application for later use in your Stimulus controllers
export { application }


import "trix"
import "@rails/actiontext"
import "./trix_underline_extension_controller"
import "./trix_underline_controller";
