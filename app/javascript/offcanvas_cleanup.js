document.addEventListener("turbo:before-cache", () => {
  const offcanvasEl = document.getElementById("sideMenu");

  if (offcanvasEl) {
    // Remove 'show' class and reset styles to prevent offcanvas from getting stuck
    offcanvasEl.classList.remove("show");
    offcanvasEl.removeAttribute("aria-modal");
    offcanvasEl.setAttribute("aria-hidden", "true");
    offcanvasEl.style.visibility = "hidden";

    // Remove backdrop manually if it exists
    const backdrop = document.querySelector(".offcanvas-backdrop");
    if (backdrop) backdrop.remove();

    // Dispose Bootstrap instance
    const instance = bootstrap.Offcanvas.getInstance(offcanvasEl);
    if (instance) instance.dispose();
  }
});
