// Step A: Before Turbo caches the page, clean up the offcanvas state
document.addEventListener("turbo:before-cache", () => {
  const offcanvasEl = document.getElementById("sideMenu");

  if (offcanvasEl) {
    // Remove 'show' and related attributes/styles
    offcanvasEl.classList.remove("show");
    offcanvasEl.removeAttribute("aria-modal");
    offcanvasEl.setAttribute("aria-hidden", "true");
    offcanvasEl.style.visibility = "hidden";

    // Remove the backdrop if it exists
    const backdrop = document.querySelector(".offcanvas-backdrop");
    if (backdrop) backdrop.remove();

    // Dispose existing Bootstrap Offcanvas instance if any
    const instance = bootstrap.Offcanvas.getInstance(offcanvasEl);
    if (instance) instance.dispose();
  }
});

// Step B: When Turbo loads a new page, re-initialize the Offcanvas component
document.addEventListener("turbo:load", () => {
  const offcanvasEl = document.getElementById("sideMenu");

  // Only initialize if it’s not already initialized
  if (offcanvasEl && !bootstrap.Offcanvas.getInstance(offcanvasEl)) {
    new bootstrap.Offcanvas(offcanvasEl);
  }
});
