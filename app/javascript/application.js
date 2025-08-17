// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

// app/javascript/application.js
import ahoy from "ahoy.js"

ahoy.configure({
  visitsUrl: "/ahoy/visits",
  eventsUrl: "/ahoy/events",
  trackVisits: true,    // automatically track page visits
  trackActions: true    // automatically track clicks with data-remote or data-event
})

// Optional: manually track page view to ensure URL is included
ahoy.track("Viewed page", {
  url: window.location.pathname + window.location.search,
  title: document.title
})


// import "./offcanvas_cleanup"
// import "./offcanvas_fix"

import "trix"
import "@rails/actiontext"

// 2. Add custom underline attribute if not already defined
if (!Trix.config.textAttributes.underline) {
  Trix.config.textAttributes.underline = {
    tagName: "u",
    style: { textDecoration: "underline" },
    inheritable: true,
    parser(element) {
      const style = window.getComputedStyle(element)
      return style.textDecoration === "underline"
    }
  }
}
