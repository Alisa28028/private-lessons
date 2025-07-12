# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "flatpickr" # @4.6.13
pin "fullcalendar", to: "https://cdn.skypack.dev/@fullcalendar/core"
pin "fullcalendar-daygrid", to: "https://cdn.skypack.dev/@fullcalendar/daygrid"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
