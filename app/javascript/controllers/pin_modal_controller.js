import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["digit", "modal", "error"]
  static values = {
    length: { type: Number, default: 4 },
    autoOpen: { type: Boolean, default: false },
    cutUrl: { type: String, default: "" }
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
    this.hideError()
  }

  delete() {
    this.code = this.code.slice(0, -1)
    this.renderDigits()
  }

  clear() {
    this.code = ""
    this.renderDigits()
    this.hideError()
  }

  submit() {
    if (this.code.length < this.lengthValue) {
      this.showError()
      return
    }
    if (!this.cutUrlValue) return

    const form = document.createElement("form")
    form.method = "post"
    form.action = this.cutUrlValue

    const csrf = document.querySelector("meta[name='csrf-token']")?.content
    if (csrf) {
      const token = document.createElement("input")
      token.type = "hidden"
      token.name = "authenticity_token"
      token.value = csrf
      form.appendChild(token)
    }

    const pin = document.createElement("input")
    pin.type = "hidden"
    pin.name = "pin"
    pin.value = this.code
    form.appendChild(pin)

    document.body.appendChild(form)
    form.submit()
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

    if (event.key === "Enter") {
      event.preventDefault()
      this.submit()
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
      this.hideError()
    }
  }

  renderDigits() {
    this.digitTargets.forEach((el, index) => {
      el.textContent = this.code[index] ? "•" : ""
      el.classList.toggle("border-roi-accent", index === this.code.length && this.code.length < this.lengthValue)
    })
  }

  showError() {
    if (this.hasErrorTarget) this.errorTarget.classList.remove("hidden")
  }

  hideError() {
    if (this.hasErrorTarget) this.errorTarget.classList.add("hidden")
  }
}
