require "test_helper"

class ProdutoTest < ActiveSupport::TestCase
  test "requires name description and non-negative price" do
    produto = Produto.new

    assert_not produto.valid?
    assert produto.errors[:nome].present?
    assert produto.errors[:descricao].present?
    assert produto.errors[:preco].present?
  end
end
