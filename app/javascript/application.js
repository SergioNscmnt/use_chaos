// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "@tabler/core"
import "./controllers"

document.addEventListener("click", (event) => {
  const skipLink = event.target.closest(".skip-link")
  if (!skipLink) return

  const target = document.querySelector(skipLink.hash)
  if (target) requestAnimationFrame(() => target.focus())
})
