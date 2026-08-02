module ApplicationHelper
  ICONES_ACAO = {
    adicionar: [ "M12 5v14", "M5 12h14" ],
    aprovar: [ "M5 12l5 5l10 -10" ],
    atualizar: [ "M20 11a8.1 8.1 0 0 0 -15.5 -2m-.5 -4v4h4", "M4 13a8.1 8.1 0 0 0 15.5 2m.5 4v-4h-4" ],
    cancelar: [ "M18 6l-12 12", "M6 6l12 12" ],
    carrinho: [ "M4 19a2 2 0 1 0 4 0a2 2 0 0 0 -4 0", "M12.5 17h-6.5v-14h-2", "M6 5l14 1l-1 7h-13", "M16 19a2 2 0 1 0 4 0a2 2 0 0 0 -4 0" ],
    download: [ "M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2 -2v-2", "M7 11l5 5l5 -5", "M12 4v12" ],
    editar: [ "M7 7h-2a2 2 0 0 0 -2 2v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-2", "M9 15l10.5 -10.5a2.1 2.1 0 0 1 3 3l-10.5 10.5h-3v-3" ],
    enviar: [ "M10 14l11 -11", "M21 3l-6.5 18a.55 .55 0 0 1 -1 0l-3.5 -7l-7 -3.5a.55 .55 0 0 1 0 -1l18 -6.5" ],
    entrar: [ "M14 8l4 4l-4 4", "M18 12h-13", "M5 5v-1a1 1 0 0 1 1 -1h7a1 1 0 0 1 1 1v2", "M14 17v2a1 1 0 0 1 -1 1h-7a1 1 0 0 1 -1 -1v-1" ],
    arquivo: [ "M14 3v4a1 1 0 0 0 1 1h4", "M5 13v-8a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2h-5", "M3 15h6", "M6 12l3 3l-3 3" ],
    filtrar: [ "M4 4h16v2.172a2 2 0 0 1 -.586 1.414l-5.414 5.414v7l-4 -2v-5l-5.414 -5.414a2 2 0 0 1 -.586 -1.414v-2.172" ],
    inativar: [ "M18.364 18.364a9 9 0 1 1 -12.728 -12.728a9 9 0 0 1 12.728 12.728", "M5.636 5.636l12.728 12.728" ],
    limpar: [ "M3 6h18", "M8 6v-2h8v2", "M19 6l-1 14h-12l-1 -14", "M10 11v5", "M14 11v5" ],
    mensagem: [ "M8 9h8", "M8 13h6", "M12 21l-1 -1h-7a2 2 0 0 1 -2 -2v-12a2 2 0 0 1 2 -2h16a2 2 0 0 1 2 2v9a2 2 0 0 1 -2 2h-3l-5 4" ],
    ocultar: [ "M3 3l18 18", "M10.584 10.587a2 2 0 0 0 2.828 2.828", "M9.878 4.242a9.8 9.8 0 0 1 2.122 -.242c4 0 7.333 2.333 10 7c-.778 1.361 -1.63 2.47 -2.553 3.326", "M6.61 6.61c-1.072 .823 -2.109 1.953 -3.11 3.39c2.667 4.667 6 7 10 7c.84 0 1.644 -.103 2.414 -.309" ],
    pesquisar: [ "M3 10a7 7 0 1 0 14 0a7 7 0 0 0 -14 0", "M21 21l-6 -6" ],
    rejeitar: [ "M18 6l-12 12", "M6 6l12 12" ],
    remover: [ "M4 7h16", "M10 11v6", "M14 11v6", "M5 7l1 14h12l1 -14", "M9 7v-3h6v3" ],
    sair: [ "M10 8l-4 4l4 4", "M6 12h12", "M18 5v-1a1 1 0 0 0 -1 -1h-7a1 1 0 0 0 -1 1v2", "M9 18v2a1 1 0 0 0 1 1h7a1 1 0 0 0 1 -1v-1" ],
    salvar: [ "M6 4h11l3 3v13h-16v-16h2", "M8 4v6h8v-6", "M8 20v-6h8v6" ],
    visualizar: [ "M2 12c2.667 -4.667 6 -7 10 -7s7.333 2.333 10 7c-2.667 4.667 -6 7 -10 7s-7.333 -2.333 -10 -7", "M9 12a3 3 0 1 0 6 0a3 3 0 0 0 -6 0" ],
    voltar: [ "M15 6l-6 6l6 6", "M9 12h12" ],
    whatsapp: [ "M3 21l1.65 -3.8a9 9 0 1 1 3.4 2.9l-5.05 .9", "M9 10a.5 .5 0 0 0 1 0v-1a.5 .5 0 0 0 -1 0v1a5 5 0 0 0 5 5h1a.5 .5 0 0 0 0 -1h-1a.5 .5 0 0 0 0 1" ]
  }.freeze

  TONS_BADGE = {
    primario: "primario",
    destaque: "destaque",
    sucesso: "sucesso",
    informacao: "informacao",
    perigo: "perigo",
    atencao: "atencao",
    neutro: "neutro"
  }.freeze

  def moeda_centavos(valor)
    number_to_currency(valor.to_i / 100.0)
  end

  def valor_monetario_digitado(valor)
    centavos = Valores::Monetario.para_centavos(valor)
    centavos.nil? ? valor : Valores::Monetario.formatar(centavos)
  end

  def badge_neon(texto, tom: :neutro, classes: nil)
    tom_css = TONS_BADGE.fetch(tom, TONS_BADGE.fetch(:neutro))
    tag.span(
      texto,
      class: class_names("badge", "badge-neon", "badge-neon--#{tom_css}", classes)
    )
  end

  def badge_situacao(situacao)
    tons = {
      "iniciado" => :primario,
      "nova" => :primario,
      "em_atendimento" => :destaque,
      "em_analise" => :destaque,
      "confirmado" => :sucesso,
      "concluido" => :informacao,
      "tratada" => :sucesso,
      "cancelado" => :perigo,
      "pendente" => :atencao,
      "aprovada" => :sucesso,
      "rejeitada" => :perigo
    }
    badge_neon(situacao.to_s.humanize, tom: tons.fetch(situacao.to_s, :neutro))
  end

  def icone_acao(nome, classes: nil, data: nil)
    caminhos = ICONES_ACAO.fetch(nome.to_sym)
    tag.svg(
      safe_join(caminhos.map { |caminho| tag.path(d: caminho) }),
      class: class_names("icone-botao", classes),
      xmlns: "http://www.w3.org/2000/svg",
      width: 20,
      height: 20,
      viewBox: "0 0 24 24",
      fill: "none",
      stroke: "currentColor",
      stroke_width: 2,
      stroke_linecap: "round",
      stroke_linejoin: "round",
      aria: { hidden: true },
      focusable: "false",
      data:
    )
  end

  def conteudo_botao(texto, icone)
    safe_join([ icone_acao(icone), tag.span(texto) ])
  end

  def imagens_exibiveis(produto)
    produto.imagens_produto
      .select do |imagem|
        imagem.arquivo.attached? &&
          imagem.arquivo.blob.persisted? &&
          !imagem.marked_for_destruction?
      end
      .sort_by { |imagem| [ imagem.principal? ? 0 : 1, imagem.posicao, imagem.id.to_i ] }
  end
end
