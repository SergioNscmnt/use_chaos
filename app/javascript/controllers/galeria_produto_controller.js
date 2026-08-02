import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lista", "modelo"]

  connect() {
    this.element.dataset.galeriaProdutoPronta = "true"
  }

  adicionar() {
    // Rails reconhece coleções aninhadas de `params.expect` por índices numéricos.
    const indice = `${Date.now()}${Math.floor(Math.random() * 1000).toString().padStart(3, "0")}`
    const html = this.modeloTarget.innerHTML.replaceAll("NOVA_IMAGEM", indice)

    this.listaTarget.insertAdjacentHTML("beforeend", html)
    this.listaTarget.lastElementChild.querySelector("input[type='file']")?.focus()
  }

  remover(event) {
    const item = event.currentTarget.closest("[data-galeria-produto-item]")
    const campoDestruicao = item.querySelector("input[name$='[_destroy]']")

    if (item.dataset.persistida === "true") {
      campoDestruicao.value = "1"
      item.hidden = true
    } else {
      item.remove()
    }
  }

  selecionarPrincipal(event) {
    if (!event.currentTarget.checked) return

    this.element.querySelectorAll("input[name$='[principal]']").forEach((campo) => {
      if (campo !== event.currentTarget) campo.checked = false
    })
  }

  previsualizar(event) {
    const arquivo = event.currentTarget.files[0]
    if (!arquivo) return

    const item = event.currentTarget.closest("[data-galeria-produto-item]")
    const imagem = item.querySelector("[data-preview-imagem]")
    const placeholder = item.querySelector("[data-preview-placeholder]")
    const url = URL.createObjectURL(arquivo)

    imagem.src = url
    imagem.classList.remove("d-none")
    imagem.removeAttribute("aria-hidden")
    placeholder?.classList.add("d-none")
    imagem.addEventListener("load", () => URL.revokeObjectURL(url), { once: true })
  }
}
