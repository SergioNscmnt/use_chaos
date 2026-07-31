module ApplicationHelper
  def moeda_centavos(valor)
    number_to_currency(valor.to_i / 100.0)
  end

  def badge_situacao(situacao)
    classes = {
      "iniciado" => "bg-purple-lt",
      "em_atendimento" => "bg-orange-lt",
      "confirmado" => "bg-green-lt",
      "concluido" => "bg-azure-lt",
      "cancelado" => "bg-red-lt",
      "pendente" => "bg-yellow-lt",
      "aprovada" => "bg-green-lt",
      "rejeitada" => "bg-red-lt"
    }
    tag.span(situacao.to_s.humanize, class: "badge #{classes.fetch(situacao.to_s, 'bg-secondary-lt')}")
  end
end
