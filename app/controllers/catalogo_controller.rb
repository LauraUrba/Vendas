class CatalogoController < ApplicationController
  def index
    @produtos = Produto.with_attached_imagens.order(:nome)

    if params[:busca].present?
      termo = "%#{Produto.sanitize_sql_like(params[:busca])}%"
      @produtos = @produtos.where("nome ILIKE ? OR descricao ILIKE ?", termo, termo)
      
        # ILIKE é usado para busca case-insensitive no PostgreSQL.
        # Se estiver usando outro banco, ajuste a consulta.
        # Permite pesquisas sem diferenciar maiúsculas no PostgreSQL.
    end
  end

  def show
    @produto = Produto.find(params[:id])
  end

end 