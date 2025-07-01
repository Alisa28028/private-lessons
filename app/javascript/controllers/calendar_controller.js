import { Controller } from "@hotwired/stimulus"
import { Calendar } from "fullcalendar"
import dayGridPlugin from "fullcalendar-daygrid"

export default class extends Controller {
  connect() {
    const calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth",
      events: "/bookings.json" // or however your bookings are served
    })

    calendar.render()
  }
}
