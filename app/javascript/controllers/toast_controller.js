import { Toast } from "@tabler/core"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    autohide: { type: Boolean, default: true },
    delay: { type: Number, default: 5000 }
  }

  connect() {
    this.remover = this.remover.bind(this)
    this.element.addEventListener("hidden.bs.toast", this.remover, { once: true })
    this.toast = Toast.getOrCreateInstance(this.element, {
      autohide: this.autohideValue,
      delay: this.delayValue
    })
    this.toast.show()
  }

  disconnect() {
    this.element.removeEventListener("hidden.bs.toast", this.remover)
    this.toast?.dispose()
  }

  remover() {
    this.element.remove()
  }
}
