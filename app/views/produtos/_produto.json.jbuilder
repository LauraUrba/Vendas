json.extract! produto, :id, :nome, :descricao, :preco, :created_at, :updated_at
json.imagens produto.imagens.map { |imagem| url_for(imagem) }
json.url produto_url(produto, format: :json)
