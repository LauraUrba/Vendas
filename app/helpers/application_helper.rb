module ApplicationHelper
    def preco_br(valor)
        number_to_currency(valor, unit: "R$", separator: ",", delimiter: ".")
    end

    def cpf_formatado(cpf)
        cpf.to_s.sub(/\A(\d{3})(\d{3})(\d{3})(\d{2})\z/, '\1.\2.\3-\4')
    end
end
