class Rack::Attack
  Rack::Attack.cache.store = Rails.cache

  throttle("formularios-publicos/ip", limit: 20, period: 10.minutes) do |request|
    formulario_publico = request.path.match?(
      %r{\A/(?:produtos/[^/]+/avaliacoes|manifestacoes|checkout)\z}
    )
    if request.post? && formulario_publico
      request.ip
    end
  end

  self.throttled_responder = lambda do |_request|
    [
      429,
      { "Content-Type" => "text/plain; charset=utf-8", "Retry-After" => "600" },
      [ "Muitas tentativas. Aguarde alguns minutos e tente novamente." ]
    ]
  end
end

Rails.application.config.middleware.use Rack::Attack
