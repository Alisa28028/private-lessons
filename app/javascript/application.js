// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

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
