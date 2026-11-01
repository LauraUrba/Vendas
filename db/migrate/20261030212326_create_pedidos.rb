class CreatePedidos < ActiveRecord::Migration[8.1]
  def change
    create_table :pedidos do |t|
      t.string :nome
      t.string :cpf
      t.string :email
      t.string :endereco
      t.string :forma_pagamento
      t.string :status, null: false, default: "criado"
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
