class Pedido < ApplicationRecord
    FORMAS_PAGAMENTO = {
        "credito" => "Cartão de crédito",
        "debito"  => "Cartão de débito",
        "pix"     => "Pix"
    }.freeze
    STATUS = %w[criado cancelado].freeze

    has_many :line_items

    before_validation :limpar_cpf

    validates :nome, :email, :endereco, presence: true
    validates :cpf, presence: true, cpf: true
    validates :forma_pagamento, inclusion: { in: FORMAS_PAGAMENTO.keys }
    validates :status, inclusion: { in: STATUS }

    def cancelado?
        status == "cancelado"
    end

    def cancelar!
        update!(status: "cancelado") unless cancelado?
    end

    private def limpar_cpf
        self.cpf = cpf.to_s.gsub(/\D/, "")
    end
end