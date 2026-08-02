require "test_helper"

Selenium::WebDriver.logger.level = :warn

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1_440, 900 ] do |opcoes|
    chrome_local = Dir[File.join(Dir.home, ".cache/selenium/chrome/linux64/*/chrome")].max
    opcoes.binary = ENV["CHROME_BIN"].presence || chrome_local if ENV["CHROME_BIN"].present? || chrome_local
    opcoes.add_argument("--no-sandbox")
    opcoes.add_argument("--disable-dev-shm-usage")
  end

  private

  def assert_sem_rolagem_horizontal
    largura_documento = page.evaluate_script("document.documentElement.scrollWidth")
    largura_viewport = page.evaluate_script("window.innerWidth")
    bordas_raiz = page.evaluate_script(<<~JAVASCRIPT)
      (() => {
        const raiz = document.documentElement.getBoundingClientRect();
        return {
          esquerda: Math.round(raiz.left),
          direita: Math.round(raiz.right),
          largura_util: document.documentElement.clientWidth
        };
      })()
    JAVASCRIPT
    elementos_excedentes = page.evaluate_script(<<~JAVASCRIPT)
      Array.from(document.querySelectorAll("body *"))
        .map(elemento => {
          const retangulo = elemento.getBoundingClientRect();
          return {
            seletor: `${elemento.tagName.toLowerCase()}${elemento.id ? "#" + elemento.id : ""}${elemento.className ? "." + String(elemento.className).trim().replaceAll(" ", ".") : ""}`,
            esquerda: Math.round(retangulo.left),
            direita: Math.round(retangulo.right),
            largura: Math.round(retangulo.width)
          };
        })
        .filter(item => item.esquerda < 0 || item.direita > document.documentElement.clientWidth)
        .slice(0, 10)
    JAVASCRIPT
    assert_operator largura_documento, :<=, largura_viewport,
      "Elementos fora do viewport: #{elementos_excedentes.inspect}"
    assert_equal 0, bordas_raiz["esquerda"],
      "A aplicação deixou uma sobra na borda esquerda: #{bordas_raiz.inspect}"
    assert_equal bordas_raiz["largura_util"], bordas_raiz["direita"],
      "A aplicação deixou uma sobra na borda direita: #{bordas_raiz.inspect}"
    page.execute_script("window.scrollTo({ left: 10000, top: window.scrollY, behavior: 'instant' })")
    assert_equal 0, page.evaluate_script("window.scrollX"),
      "A página permite rolagem horizontal. Elementos fora do viewport: #{elementos_excedentes.inspect}"
  end

  def assert_controles_contidos
    controles_excedentes = page.evaluate_script(<<~JAVASCRIPT)
      Array.from(document.querySelectorAll(".form-control, .form-select"))
        .filter(elemento => elemento.offsetParent !== null)
        .map(elemento => {
          const controle = elemento.getBoundingClientRect();
          const recipiente = elemento.parentElement.getBoundingClientRect();
          return {
            campo: elemento.id || elemento.name,
            esquerda: Math.round(controle.left),
            direita: Math.round(controle.right),
            recipiente_esquerda: Math.round(recipiente.left),
            recipiente_direita: Math.round(recipiente.right)
          };
        })
        .filter(item =>
          item.esquerda < item.recipiente_esquerda - 1 ||
          item.direita > item.recipiente_direita + 1
        )
    JAVASCRIPT

    assert_empty controles_excedentes,
      "Controles de formulário excedem seus recipientes: #{controles_excedentes.inspect}"
  end

  def assert_midias_contidas_nos_cards
    problemas = page.evaluate_script(<<~JAVASCRIPT)
      Array.from(document.querySelectorAll(".card-produto")).flatMap(card => {
        const midia = card.querySelector(".card-produto__midia");
        const corpo = card.querySelector(".card-body");
        const caixaCard = card.getBoundingClientRect();
        const caixaMidia = midia.getBoundingClientRect();
        const caixaCorpo = corpo.getBoundingClientRect();
        const estiloCard = getComputedStyle(card);
        const problemasCard = [];

        if (
          caixaMidia.left < caixaCard.left - 1 ||
          caixaMidia.right > caixaCard.right + 1 ||
          caixaMidia.top < caixaCard.top - 1 ||
          caixaMidia.bottom > caixaCorpo.top + 1
        ) {
          problemasCard.push({ tipo: "midia-fora-do-card", card: caixaCard.toJSON(), midia: caixaMidia.toJSON(), corpo: caixaCorpo.toJSON() });
        }

        if (estiloCard.overflow !== "hidden") {
          problemasCard.push({ tipo: "card-sem-recorte", overflow: estiloCard.overflow });
        }

        return problemasCard;
      })
    JAVASCRIPT

    assert_empty problemas, "Imagens ou placeholders excedem os cards: #{problemas.inspect}"
  end

  def assert_rodape_sem_sobreposicao
    geometria = page.evaluate_script(<<~JAVASCRIPT)
      (() => {
        const conteudo = document.querySelector("main#conteudo-principal");
        const rodape = document.querySelector("footer.rodape-publico");
        const caixaConteudo = conteudo.getBoundingClientRect();
        const caixaRodape = rodape.getBoundingClientRect();

        return {
          fimConteudo: Math.round(caixaConteudo.bottom + window.scrollY),
          inicioRodape: Math.round(caixaRodape.top + window.scrollY),
          fimRodape: Math.round(caixaRodape.bottom + window.scrollY),
          fimBody: Math.round(document.body.getBoundingClientRect().bottom + window.scrollY),
          fimRaiz: Math.round(document.documentElement.getBoundingClientRect().bottom + window.scrollY),
          alturaDocumento: document.documentElement.scrollHeight,
          alturaViewport: window.innerHeight,
          alturaBody: Math.round(document.body.getBoundingClientRect().height),
          classesBody: document.body.className,
          displayBody: getComputedStyle(document.body).display,
          posicaoRodape: getComputedStyle(rodape).position
        };
      })()
    JAVASCRIPT

    assert_not_includes %w[absolute fixed], geometria["posicaoRodape"],
      "O rodapé não deve sair do fluxo normal da página: #{geometria.inspect}"
    assert_operator geometria["inicioRodape"], :>=, geometria["fimConteudo"] - 1,
      "O rodapé está sobrepondo o conteúdo principal: #{geometria.inspect}"
    assert_operator geometria["fimRodape"], :>=, geometria["alturaViewport"] - 1,
      "Em páginas curtas, o rodapé deve permanecer no fim da viewport: #{geometria.inspect}"
    assert_operator geometria["fimRodape"], :<=, geometria["alturaDocumento"] + 1,
      "O rodapé deve permanecer dentro da altura do documento: #{geometria.inspect}"
    assert_operator geometria["fimRodape"], :<=, geometria["fimBody"] + 1,
      "O fundo da aplicação deve acompanhar o rodapé: #{geometria.inspect}"
    assert_operator geometria["fimRodape"], :<=, geometria["fimRaiz"] + 1,
      "A raiz da página deve acompanhar o rodapé: #{geometria.inspect}"
  end

  def assert_paginacao_separada_do_rodape
    geometria = page.evaluate_script(<<~JAVASCRIPT)
      (() => {
        const paginacao = document.querySelector("nav[aria-label='Paginação do catálogo']");
        const rodape = document.querySelector("footer.rodape-publico");
        const fimPaginacao = paginacao.getBoundingClientRect().bottom + window.scrollY;
        const inicioRodape = rodape.getBoundingClientRect().top + window.scrollY;

        return {
          fimPaginacao: Math.round(fimPaginacao),
          inicioRodape: Math.round(inicioRodape),
          separacao: Math.round(inicioRodape - fimPaginacao)
        };
      })()
    JAVASCRIPT

    assert_operator geometria["separacao"], :>=, 48,
      "A paginação está muito próxima ou sobrepondo o rodapé: #{geometria.inspect}"
  end

  def violacoes_axe
    page.execute_script(Rails.root.join("node_modules/axe-core/axe.min.js").read)
    page.evaluate_async_script(<<~JAVASCRIPT)
      const concluir = arguments[0];
      axe.run(document, {
        runOnly: { type: "tag", values: ["wcag2a", "wcag2aa", "wcag21aa"] }
      }).then(resultado => {
        concluir(resultado.violations.map(violacao => ({
          id: violacao.id,
          impacto: violacao.impact,
          ajuda: violacao.help,
          alvos: violacao.nodes.map(no => no.target)
        })));
      }).catch(erro => concluir([{ id: "axe-error", ajuda: erro.message }]));
    JAVASCRIPT
  end
end

class SemJavaScriptSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test
end
