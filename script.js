/* ==========================================================================
   script.js
   --------------------------------------------------------------------------
   Generic example/template JavaScript file.
   Pairs with index.html and style.css. Organised into clearly labelled
   sections — delete what you don't need, build on what you do.
   ========================================================================== */


/* --------------------------------------------------------------------------
   1. Run after the DOM is ready
   -------------------------------------------------------------------------- */
document.addEventListener("DOMContentLoaded", () => {
  initSmoothScroll();
  initButtonHandlers();
  initActiveNavHighlight();
});


/* --------------------------------------------------------------------------
   2. Smooth scrolling for in-page nav links (e.g. <a href="#about">)
   -------------------------------------------------------------------------- */
function initSmoothScroll() {
  const navLinks = document.querySelectorAll('a[href^="#"]');

  navLinks.forEach((link) => {
    link.addEventListener("click", (event) => {
      const targetId = link.getAttribute("href").slice(1);
      const targetEl = document.getElementById(targetId);

      if (targetEl) {
        event.preventDefault();
        targetEl.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    });
  });
}


/* --------------------------------------------------------------------------
   3. Button click handlers
   -------------------------------------------------------------------------- */
function initButtonHandlers() {
  const primaryBtn = document.querySelector(".btn-primary");
  const secondaryBtn = document.querySelector(".btn-secondary");

  if (primaryBtn) {
    primaryBtn.addEventListener("click", () => {
      // Replace with real behavior: open a modal, navigate, submit a form, etc.
      console.log("Primary button clicked — add your action here.");
    });
  }

  if (secondaryBtn) {
    secondaryBtn.addEventListener("click", () => {
      const aboutSection = document.getElementById("about");
      if (aboutSection) {
        aboutSection.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    });
  }
}


/* --------------------------------------------------------------------------
   4. Highlight the nav link matching the section currently in view
   -------------------------------------------------------------------------- */
function initActiveNavHighlight() {
  const sections = document.querySelectorAll("main section[id]");
  const navLinks = document.querySelectorAll(".site-header nav a");

  if (sections.length === 0 || navLinks.length === 0) return;

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const id = entry.target.getAttribute("id");

          navLinks.forEach((link) => {
            const isActive = link.getAttribute("href") === `#${id}`;
            link.style.fontWeight = isActive ? "700" : "400";
          });
        }
      });
    },
    { threshold: 0.5 }
  );

  sections.forEach((section) => observer.observe(section));
}


/* --------------------------------------------------------------------------
   5. Utility: simple debounce (handy for resize/scroll/input listeners)
   -------------------------------------------------------------------------- */
function debounce(fn, delay = 200) {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}