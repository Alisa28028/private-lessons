import { Controller } from "@hotwired/stimulus"
import { Calendar } from "fullcalendar"
import dayGridPlugin from "fullcalendar-daygrid"

export default class extends Controller {
  connect() {
    const calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth",
      events: "/bookings.json",

      eventDidMount: function(info) {
        const avatarUrl = info.event.extendedProps.teacher_avatar
        const title = info.event.title
        const waitlisted = info.event.extendedProps.waitlisted
        const status = info.event.extendedProps.status


        const start = new Date(info.event.start).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false })
        const end = info.event.end
          ? new Date(info.event.end).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false })
          : null
        const timeRange = end ? `${start} ~ ${end}` : start

        const location = info.event.extendedProps.location || "No location provided"

        if (avatarUrl) {
          const img = document.createElement("img")
          img.src = avatarUrl
          img.alt = "teacher avatar"
          img.style.width = "20px"
          img.style.height = "20px"
          img.style.borderRadius = "50%"
          img.style.marginRight = "5px"
          img.style.verticalAlign = "middle"
          img.style.cursor = "pointer"

          if (waitlisted || status === "pending") {
            img.style.opacity = "0.4"
          }

          img.addEventListener("click", (e) => {
            e.stopPropagation()

            // Remove existing popovers
            const existing = document.querySelector(".fc-avatar-popover")
            if (existing) existing.remove()

            // Create popover
            const popover = document.createElement("div")
            popover.className = "fc-avatar-popover"
            popover.style.position = "absolute"
            popover.style.background = "white"
            popover.style.border = "1px solid #ddd"
            popover.style.borderRadius = "0.5rem"
            popover.style.padding = "0.5rem"
            popover.style.boxShadow = "0 2px 8px rgba(0,0,0,0.1)"
            popover.style.zIndex = 1000
            popover.style.fontFamily = "Inter"
            popover.style.color = "#292A5A"
            popover.style.lineHeight = 1.5
            popover.style.fontSize = "13px"

            let statusLabel = ""
            if (status === "pending" && !waitlisted) {
              statusLabel = `<div style="color: #9747FF; font-weight: bold;">Pending approval</div>`
            } else if (waitlisted) {
              statusLabel = `<div style="color: #9747FF; font-weight: bold;">Waitlisted</div>`
            }

            popover.innerHTML = `
              <strong>${title}</strong><br>
              ${statusLabel}
              <small><i class="fa-regular fa-clock fa-sm text-custom"></i> ${timeRange}</small><br>
              <small><i class="fa-solid fa-location-dot fa-md text-custom"></i> ${location}</small>
            `


            document.body.appendChild(popover)

            const rect = img.getBoundingClientRect()
            popover.style.top = `${rect.bottom + window.scrollY + 4}px`
            popover.style.left = `${rect.left + window.scrollX}px`

            // Close on outside click
            const handler = (ev) => {
              if (!popover.contains(ev.target)) {
                popover.remove()
                document.removeEventListener("click", handler)
              }
            }
            document.addEventListener("click", handler)
          })

          // Replace event content with avatar only
          info.el.innerHTML = ""
          info.el.appendChild(img)
        }
      }
    })

    calendar.render()
  }
}
