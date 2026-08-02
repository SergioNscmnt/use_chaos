import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { minimoDigitos: { type: Number, default: 1 } }

  connect() {
    this.formatar()
  }

  formatar() {
    const valor = this.element.value
    if (/[a-z@]/i.test(valor)) return

    let digitos = valor.replace(/\D/g, "")
    if (digitos.length < this.minimoDigitosValue) return

    let prefixo = ""
    if (digitos.length > 11 && digitos.startsWith("55")) {
      prefixo = "+55 "
      digitos = digitos.slice(2)
    }
    digitos = digitos.slice(0, 11)

    if (digitos === "") {
      this.element.value = ""
      return
    }

    const ddd = digitos.slice(0, 2)
    const numero = digitos.slice(2)
    let formatado = `(${ddd}`
    if (digitos.length >= 2) formatado += ")"
    if (numero.length > 0) {
      const tamanhoPrefixo = numero.length > 8 ? 5 : 4
      formatado += ` ${numero.slice(0, tamanhoPrefixo)}`
      if (numero.length > tamanhoPrefixo) formatado += `-${numero.slice(tamanhoPrefixo)}`
    }

    this.element.value = `${prefixo}${formatado}`
  }
}
