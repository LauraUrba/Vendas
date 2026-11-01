class CpfValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        return if value.blank?

        record.errors.add(attribute, "é inválido") unless valido?(value)
    end

    private def valido?(cpf)
        digitos = cpf.to_s.gsub(/\D/, "")
        return false unless digitos.length == 11
        return false if digitos.chars.uniq.length == 1

        numeros = digitos.chars.map(&:to_i)

        [9, 10].all? do |tamanho|
        soma = numeros.first(tamanho).each_with_index.sum { |n, i| n * (tamanho + 1 - i) }
        resto = (soma * 10) % 11
        resto = 0 if resto == 10
        resto == numeros[tamanho]
        end
    end
end