class ProdutosController < ApplicationController
  before_action :set_produto, only: %i[ show edit update destroy ]

  # GET /produtos or /produtos.json
  def index
    @produtos = Produto.all
  end

  # GET /produtos/1 or /produtos/1.json
  def show
  end

  # GET /produtos/buscar.json?q=nome
  def buscar
    termo = params[:q].to_s.strip
    @produtos = Produto.with_attached_imagens

    if termo.present?
      busca = "%#{Produto.sanitize_sql_like(termo)}%"
      @produtos = @produtos.where("nome ILIKE ? OR descricao ILIKE ?", busca, busca)
    end

    respond_to do |format|
      format.json { render :index }
    end
  end

  # GET /produtos/new
  def new
    @produto = Produto.new
  end

  # GET /produtos/1/edit
  def edit
  end

  # POST /produtos or /produtos.json
  def create
    @produto = Produto.new(produto_params)

    respond_to do |format|
      if @produto.save
        format.html { redirect_to @produto, notice: "Produto was successfully created." }
        format.json { render :show, status: :created, location: @produto }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @produto.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /produtos/1 or /produtos/1.json
  def update
    respond_to do |format|
      if @produto.update(produto_params)
        format.html { redirect_to @produto, notice: "Produto was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @produto }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @produto.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /produtos/1 or /produtos/1.json
  def destroy
    @produto.destroy!

    respond_to do |format|
      format.html { redirect_to produtos_path, notice: "Produto was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produto
      @produto = Produto.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def produto_params
      params.expect(produto: [ :nome, :descricao, :preco, imagens: [] ])
    end
end
