import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (this.element.value.trim() !== "") this.formatar()
  }

  formatar() {
    const digitos = this.element.value.replace(/\D/g, "")
    if (digitos === "") {
      this.element.value = ""
      return
    }

    const valor = digitos.padStart(3, "0")
    const centavos = valor.slice(-2)
    const reais = valor.slice(0, -2).replace(/^0+(?=\d)/, "")
    const reaisFormatados = reais.replace(/\B(?=(\d{3})+(?!\d))/g, ".")
    this.element.value = `R$ ${reaisFormatados},${centavos}`
  }
}
