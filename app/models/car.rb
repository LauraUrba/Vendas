class Car < ApplicationRecord
    FRETE_FIXO = 5.0

    has_many :line_items, dependent: :destroy

    def subtotal
        line_items.includes(:produto).sum { |item| item.produto.preco * item.quantidade }
    end

    def total
        subtotal + FRETE_FIXO
    end
end
