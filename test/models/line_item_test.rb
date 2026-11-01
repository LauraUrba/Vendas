require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test "calculates subtotal" do
    produto = Produto.new(preco: 12.50)
    item = LineItem.new(produto: produto, quantidade: 3)

    assert_equal 37.50, item.subtotal
  end
end
