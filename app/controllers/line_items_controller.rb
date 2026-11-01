class LineItemsController < ApplicationController
    def create
        produto = Produto.find(params[:produto_id])
        qtd = [params.fetch(:quantidade, 1).to_i, 1].max

        item = current_car.line_items.find_or_initialize_by(produto: produto)
        #O current_car cria ou recupera o carrinho pela sessão 
        
        item.quantidade = item.new_record? ? qtd : item.quantidade + qtd
        item.save!

        redirect_to carrinho_path, notice: "#{produto.nome} adicionado ao carrinho."
    end 

    def update 
        item = current_car.line_items.find(params[:id])
        quantidade = params[:quantidade].to_i

        if quantidade > 0
            item.update!(quantidade: quantidade)
            redirect_to carrinho_path, notice: "Quantidade atualizada.", status: :see_other
        else 
            item.destroy
            redirect_to carrinho_path, notice: "Item removido do carrinho.", status: :see_other
        end
    end

    def destroy 
        current_car.line_items.find(params[:id]).destroy
        redirect_to carrinho_path, notice: "Item removido do carrinho.", status: :see_other
    end
end
