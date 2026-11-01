class RemoveImagemFromProdutos < ActiveRecord::Migration[8.1]
  def change
    remove_column :produtos, :imagem, :string
  end
end
