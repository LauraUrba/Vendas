require "test_helper"

class ProdutosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @produto = produtos(:one)
  end

  test "should get index" do
    get produtos_url
    assert_response :success
  end

  test "should get new" do
    get new_produto_url
    assert_response :success
  end

  test "should create produto" do
    assert_difference("Produto.count") do
      post produtos_url, params: {
        produto: produto_params(nome: "Produto novo").merge(imagens: imagens_teste)
      }
    end

    assert_redirected_to produto_url(Produto.last)
  end

  test "should show produto" do
    get produto_url(@produto)
    assert_response :success
  end

  test "should get edit" do
    get edit_produto_url(@produto)
    assert_response :success
  end

  test "should update produto" do
    patch produto_url(@produto), params: {
      produto: produto_params.merge(imagens: imagens_teste)
    }
    assert_redirected_to produto_url(@produto)
  end

  test "should destroy produto" do
    assert_difference("Produto.count", -1) do
      delete produto_url(@produto)
    end

    assert_redirected_to produtos_url
  end

  private

  def produto_params(nome: @produto.nome)
    { descricao: @produto.descricao, nome: nome, preco: @produto.preco }
  end

  def imagens_teste
    3.times.map do
      Rack::Test::UploadedFile.new(Rails.root.join("public/icon.png"), "image/png")
    end
  end
end
