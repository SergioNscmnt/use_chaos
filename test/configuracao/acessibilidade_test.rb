require "test_helper"

class AcessibilidadeTest < ActiveSupport::TestCase
  test "folha principal cobre foco, viewport móvel e redução de movimento" do
    css = Rails.root.join("app/assets/stylesheets/application.sass.scss").read
    layout = Rails.root.join("app/views/layouts/application.html.erb").read

    assert_includes css, ":focus-visible"
    assert_includes css, "@media (max-width: 767.98px)"
    assert_includes css, "@media (prefers-reduced-motion: reduce)"
    assert_includes css, ".skip-link:focus"
    assert_includes layout, "csrf_meta_tags"
  end

  test "combinações essenciais superam contraste WCAG AA" do
    assert_operator contraste("ff8c00", "000000"), :>=, 4.5
    assert_operator contraste("ffffff", "a020f0"), :>=, 4.5
    assert_operator contraste("c8c0d0", "000000"), :>=, 4.5
  end

  private

  def contraste(cor_a, cor_b)
    maior, menor = [ luminancia(cor_a), luminancia(cor_b) ].sort.reverse
    (maior + 0.05) / (menor + 0.05)
  end

  def luminancia(hexadecimal)
    canais = hexadecimal.scan(/../).map { |canal| canal.to_i(16) / 255.0 }
    linearizados = canais.map do |canal|
      canal <= 0.03928 ? canal / 12.92 : ((canal + 0.055) / 1.055)**2.4
    end
    (0.2126 * linearizados[0]) + (0.7152 * linearizados[1]) + (0.0722 * linearizados[2])
  end
end
