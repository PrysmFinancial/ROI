import { Controller } from "@hotwired/stimulus"

// Simple open/close modal (Adjust section, Offer alternate).
export default class extends Controller {
  static targets = ["panel"]

  open(event) {
    event?.preventDefault()
    this.panelTarget.classList.remove("hidden")
    this.panelTarget.classList.add("flex")
    document.body.classList.add("overflow-hidden")
  }

  close(event) {
    event?.preventDefault()
    this.panelTarget.classList.add("hidden")
    this.panelTarget.classList.remove("flex")
    document.body.classList.remove("overflow-hidden")
  }

  backdrop(event) {
    if (event.target === this.panelTarget) this.close()
  }

  keydown(event) {
    if (event.key === "Escape" && !this.panelTarget.classList.contains("hidden")) {
      this.close()
    }
  }
}
