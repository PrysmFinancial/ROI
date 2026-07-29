import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "confirmedCount", "pendingCount"]

  setStatus(event) {
    const row = event.currentTarget.closest("[data-confirmation-calls-target='row']")
    row.dataset.status = event.currentTarget.dataset.status

    row.querySelectorAll("[data-status]").forEach((button) => {
      const active = button.dataset.status === row.dataset.status
      button.classList.toggle("border-roi-accent/50", active)
      button.classList.toggle("bg-roi-accent/10", active)
      button.classList.toggle("text-roi-accent", active)
      button.classList.toggle("border-roi-border", !active)
      button.classList.toggle("text-roi-muted", !active)
    })

    this.updateCounts()
  }

  updateCounts() {
    const statuses = this.rowTargets.map((row) => row.dataset.status)
    this.confirmedCountTarget.textContent = statuses.filter((status) => status === "confirmed").length
    this.pendingCountTarget.textContent = statuses.filter((status) => status === "pending").length
  }
}
