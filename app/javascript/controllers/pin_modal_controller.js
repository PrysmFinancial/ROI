import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["digit", "modal"]
  static values = {
    length: { type: Number, default: 4 },
    autoOpen: { type: Boolean, default: false }
  }

  connect() {
    this.code = ""
    if (this.autoOpenValue) this.open()
  }

  open() {
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
    document.body.classList.remove("overflow-hidden")
    this.clear()
  }

  press(event) {
    const value = event.currentTarget.dataset.value
    if (this.code.length >= this.lengthValue) return

    this.code += value
    this.renderDigits()
  }

  delete() {
    this.code = this.code.slice(0, -1)
    this.renderDigits()
  }

  clear() {
    this.code = ""
    this.renderDigits()
  }

  backdrop(event) {
    if (event.target === this.modalTarget) this.close()
  }

  keydown(event) {
    if (this.modalTarget.classList.contains("hidden")) return

    if (event.key === "Escape") {
      this.close()
      return
    }

    if (event.key === "Backspace") {
      event.preventDefault()
      this.delete()
      return
    }

    if (/^\d$/.test(event.key)) {
      event.preventDefault()
      if (this.code.length >= this.lengthValue) return
      this.code += event.key
      this.renderDigits()
    }
  }

  renderDigits() {
    this.digitTargets.forEach((el, index) => {
      el.textContent = this.code[index] ? "•" : ""
      el.classList.toggle("border-roi-accent", index === this.code.length && this.code.length < this.lengthValue)
    })
  }
}
