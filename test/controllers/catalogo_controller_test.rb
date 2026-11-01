require "test_helper"

class CatalogoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get catalogo_url
    assert_response :success
  end

  test "searches by product name" do
    produto = Produto.new(nome: "Varinha Teste", descricao: "Produto mágico", preco: 10)
    produto.save!(validate: false)
    (1..3).each do |numero|
      produto.imagens.attach(
        io: StringIO.new("imagem"),
        filename: "imagem-#{numero}.jpg",
        content_type: "image/jpeg"
      )
    end

    get catalogo_url, params: { busca: "Varinha" }

    assert_response :success
    assert_select ".produto", minimum: 1
  end
end
