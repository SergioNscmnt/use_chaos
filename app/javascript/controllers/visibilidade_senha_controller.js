import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["campo", "botao", "rotulo", "iconeExibir", "iconeOcultar"]

  alternar() {
    const deveExibir = this.campoTarget.type === "password"

    this.campoTarget.type = deveExibir ? "text" : "password"
    this.rotuloTarget.textContent = deveExibir ? "Ocultar" : "Exibir"
    this.iconeExibirTarget.classList.toggle("d-none", deveExibir)
    this.iconeOcultarTarget.classList.toggle("d-none", !deveExibir)
    this.botaoTarget.setAttribute("aria-label", deveExibir ? "Ocultar senha" : "Exibir senha")
    this.botaoTarget.setAttribute("aria-pressed", deveExibir.toString())
    this.campoTarget.focus({ preventScroll: true })
  }
}
