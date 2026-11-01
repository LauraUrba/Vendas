class CreateProdutos < ActiveRecord::Migration[8.1]
  def change
    create_table :produtos do |t|
      t.string :nome
      t.text :descricao
      t.decimal :preco, precision: 10, scale: 2
      t.string :imagem

      t.timestamps
    end
  end
end
