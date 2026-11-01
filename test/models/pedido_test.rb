require "test_helper"

class PedidoTest < ActiveSupport::TestCase
  test "accepts a valid cpf" do
    pedido = Pedido.new(
      nome: "Harry Potter",
      cpf: "529.982.247-25",
      email: "harry@example.com",
      endereco: "Rua dos Alfeneiros, 4",
      forma_pagamento: "pix",
      status: "criado"
    )

    assert pedido.valid?
  end

  test "rejects an invalid cpf" do
    pedido = Pedido.new(cpf: "111.111.111-11")

    assert_not pedido.valid?
    assert pedido.errors[:cpf].present?
  end
end
