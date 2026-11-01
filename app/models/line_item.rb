class LineItem < ApplicationRecord
  belongs_to :produto
  belongs_to :car

  validates :quantidade, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    produto.preco * quantidade
  end
    belongs_to :pedido, optional: true
end
