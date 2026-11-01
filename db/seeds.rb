def anexar_imagens(produto, arquivos)
  produto.imagens.purge
  arquivos.each_with_index do |arquivo, index|
    produto.imagens.attach(
      io: File.open(arquivo),
      filename: "#{produto.nome.parameterize}-#{index + 1}.jpg",
      content_type: "image/jpeg"
    )
  end
end

produtos = [
  {
    nome: "Varinha de Saule",
    descricao: "Varinha mágica feita para estudos avançados de feitiçaria.",
    preco: 189.90,
    imagens: %w[
      storage/nw/bc/nwbc2pxa47fim8l56thpnx13m604
      storage/o4/mk/o4mkd3fr64588eim78ygrxrrisc7
      storage/so/j0/soj0x98o51u92ptx8zx32cq808du
    ]
  },
  {
    nome: "Capa da Invisibilidade",
    descricao: "Capa leve inspirada nos itens mais raros da loja.",
    preco: 249.90,
    imagens: %w[
      storage/vv/xp/vvxptdpxx0s4kx3crldqeofytqip
      storage/xt/b1/xtb1ndz7dpj1ejuinjsw6d9s7leb
      storage/zv/or/zvordwztiaqkppxlgbfnfupq1wjc
    ]
  }
]

produtos.each do |dados|
  produto = Produto.find_or_initialize_by(nome: dados[:nome])
  produto.assign_attributes(descricao: dados[:descricao], preco: dados[:preco])
  produto.save!(validate: false)

  arquivos = dados[:imagens].map { |arquivo| Rails.root.join(arquivo) }
  anexar_imagens(produto, arquivos) if produto.imagens.attachments.size != 3
  produto.validate!
end
