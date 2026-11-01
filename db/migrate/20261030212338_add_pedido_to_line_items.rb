class AddPedidoToLineItems < ActiveRecord::Migration[8.1]
  def change
    add_reference :line_items, :pedido, foreign_key: true
  end
end
