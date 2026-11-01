class Produto < ApplicationRecord
    has_many_attached :imagens
    has_many :line_items, dependent: :destroy

    validates :nome, :descricao, presence: true
    validates :preco, presence: true,
                      numericality: { greater_than_or_equal_to: 0 }
    validate :somente_imagens
    validate :quantidade_de_fotos

    private

    def somente_imagens
        imagens.each do |imagem|
        unless imagem.content_type.to_s.start_with?("image/")
            errors.add(:imagens, "devem ser arquivos de imagem")
        end
        end
    end

    def quantidade_de_fotos
        errors.add(:imagens, "devem conter exatamente 3 fotos") unless imagens.attachments.size == 3
    end
end