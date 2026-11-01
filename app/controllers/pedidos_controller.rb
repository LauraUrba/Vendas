class PedidosController < ApplicationController
    before_action :exigir_carrinho, only: [:new, :create]

    def new
        @car = current_car
        @pedido = Pedido.new
    end

    def create
        @car = current_car
        @pedido = Pedido.new(pedido_params)
        @pedido.total = @car.total

        if @pedido.save
        @car.line_items.update_all(pedido_id: @pedido.id)
        session.delete(:car_id)
        redirect_to @pedido, status: :see_other
        else
        render :new, status: :unprocessable_entity
        end
    end

    def show
        @pedido = Pedido.find(params[:id])
    end

    def update
        Pedido.find(params[:id]).cancelar!
        redirect_to pedido_path(params[:id]), status: :see_other
    end

    private def exigir_carrinho
        redirect_to carrinho_path if current_car.line_items.empty?
    end

    def pedido_params
        params.expect(pedido: [:nome, :cpf, :email, :endereco, :forma_pagamento])
    end
end