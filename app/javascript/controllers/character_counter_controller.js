import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  initialize() {
    this.update = this.update.bind(this)
  }

  connect() {
    this.update()
    this.inputTarget.addEventListener("input", this.update)
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.update)
  }

  update() {
    const length = this.inputTarget.value.length

    if (this.maxLength !== -1 && (length > this.maxLength)) {
      this.outputTarget.classList.add("text-red-500")
      this.outputTarget.value = this.charactersIndicator()
    } else {
      this.outputTarget.classList.remove("text-red-500")
      this.outputTarget.textContent = this.charactersIndicator
    }
  }

  get maxLength() {
    return this.inputTarget.maxLength;
  }

  get charactersIndicator() {
    const length = this.inputTarget.value.length;

    if (this.maxLength === -1) {
      return `${length}`;
    }

    return `${length}/${this.maxLength}`;
  }
}
