require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "badge neon aplica o tom visual solicitado" do
    html = badge_neon("Disponível", tom: :sucesso)

    assert_dom_equal(
      '<span class="badge badge-neon badge-neon--sucesso">Disponível</span>',
      html
    )
  end

  test "badge de situação usa texto e tom semântico" do
    html = badge_situacao("em_atendimento")

    assert_includes html, "Em atendimento"
    assert_includes html, "badge-neon--destaque"
    refute_includes html, "bg-orange-lt"
  end
end
