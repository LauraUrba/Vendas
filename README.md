# Loja Weasley

Loja de produtos inspirada na Gemialidade Weasley, desenvolvida como projeto

## Tecnologias utilizadas

- Ruby 4.0.9
- Ruby on Rails 8.1
- PostgreSQL
- TypeScript 7.0.2
- JavaScript e esbuild
- Hotwire Turbo e Stimulus
- Active Storage
- Jbuilder
- Ubuntu 24.04 LTS

## Objetivo da aplicação

A aplicação permite:

- consultar um catálogo de produtos;
- pesquisar produtos pelo nome ou pela descrição;
- consultar os detalhes e as três imagens de um produto;
- adicionar múltiplas unidades ao carrinho;
- alterar ou remover itens;
- calcular subtotal e total;
- cadastrar os dados de cliente, entrega e pagamento;
- validar o CPF;
- criar um pedido persistido no banco de dados.

---

## Como criar e iniciar um projeto Rails semelhante

No terminal:

```bash
rails new loja_weasley -d postgresql --javascript=esbuild
cd loja_weasley
```

O Rails utiliza essa estrutura:

- `app/models`: classes e regras de persistência dos dados;
- `app/views`: páginas HTML e respostas Jbuilder;
- `app/controllers`: recebe requisições HTTP, consulta os modelos e decide a resposta;
- `db/migrate`: define alterações do banco de dados;
- `config/routes.rb`: associa URLs aos controladores;
- `config/storage.yml`: configura os serviços de armazenamento de arquivos.

### Banco PostgreSQL

Crie um usuário administrativo no PostgreSQL:

```bash
sudo -u postgres createuser -s seu_usuario
```

Depois, ajuste usuário, senha e banco quando necessário em
`config/database.yml`.

### Executar o projeto

Instale o Foreman e as dependências Ruby, se ainda não estiverem disponíveis:

```bash
gem install foreman
rbenv rehash
bundle install
```

Depois:

```bash
bin/rails db:prepare
bin/rails db:seed
bin/dev 
```
bin/dev inicia o servidor 

Também é possível iniciar o servidor Rails diretamente:

```bash
bin/rails server
```

Por padrão, o projeto estará disponível em `http://localhost:3000`.

---

## Arquitetura Rails

### Model

Os modelos ficam em `app/models`. Eles representam os dados da aplicação e
herdam de `ApplicationRecord`, que por sua vez utiliza `ActiveRecord::Base`.

Os modelos deste projeto fazem principalmente:

- validação dos dados;
- cálculo de valores;
- definição dos relacionamentos;
- comunicação com o banco de dados.

Relacionamentos usados:

- `has_many`: indica que um registro pode possuir vários registros relacionados;
- `belongs_to`: indica que o registro atual depende de outro registro;
- `optional: true`: permite que a associação não seja obrigatória.

### Controller

Os controllers ficam em `app/controllers`. Eles:

- recebem e interpretam requisições HTTP;
- lêem ou alteram dados por meio dos modelos;
- executam ações como adicionar ao carrinho ou criar um pedido;
- escolhem HTML, JSON ou redirecionamento como resposta.

### View

As views ficam em `app/views`. As páginas HTML apresentam os dados retornados
pelos controllers.

Os arquivos `.json.jbuilder` criam respostas JSON. Por exemplo, o endpoint de
produtos pode informar o nome, o preço e os endereços das três imagens.

### Helper

Helpers contêm métodos usados pelas views. Neste projeto, por exemplo,
`ApplicationHelper` possui o método de formatação de moeda.

---

## Scaffold

O Rails pode gerar uma estrutura completa com `scaffold`:

```bash
bin/rails generate scaffold Produto nome:string descricao:text preco:decimal
```

Esse comando gera ou atualiza:

- o modelo;
- o controller;
- as views;
- testes;
- uma migration;
- rotas para os recursos REST.

O scaffold cria uma base inicial, mas não substitui a implementação das regras específicas da aplicação. Os arquivos gerados precisam ser ajustados e validados manualmente.

---

## Produtos, catálogo e busca

### Produto

Cada produto possui:

- nome;
- descrição;
- preço;
- exatamente três imagens.

O modelo [Produto](app/models/produto.rb) usa:

```ruby
has_many_attached :imagens
```

Essa associação, fornecida pelo Active Storage, permite que um produto tenha
mais de um arquivo anexado. Os modelos também validam o preço, os campos de
texto e a quantidade de imagens.

## Active Storage e imagens locais

O Active Storage mantém os metadados dos arquivos no banco de dados e salva os
conteúdos dos arquivos em um serviço de armazenamento. Neste projeto, o serviço
é local.

Instalação das tabelas:

```bash
bin/rails active_storage:install
bin/rails db:migrate
```

As opções disponíveis estão em [config/storage.yml](config/storage.yml). Em
desenvolvimento, o arquivo local é configurado em `development.rb` com:

```ruby
config.active_storage.service = :local
```

No disco, os arquivos ficam em `storage/`. O banco registra apenas metadados,
como nome original, tipo de conteúdo, tamanho e chave do arquivo.

O Active Storage oferece acesso por URL:

```ruby
url_for(imagem)
```

Cada arquivo anexado é identificado pela variável de relacionamento
`imagens`, e não por um atributo de texto chamado `imagem`.

---

### Busca do catálogo

O método `CatalogoController#index` lê o parâmetro `busca` e filtra nome e
descrição:

```ruby
@produtos.where("nome ILIKE ? OR descricao ILIKE ?", termo, termo)
```

`ILIKE` realiza uma pesquisa sem diferenciar letras maiúsculas e minúsculas.
Como é uma função do PostgreSQL, o SQL precisaria ser adaptado para outro banco
de dados, como SQLite.

Também existe o endpoint JSON dedicado:

```text
GET /produtos/buscar.json?q=termo
```

Antes da consulta, `Produto.sanitize_sql_like` protege caracteres especiais de
pesquisa e evita que sejam interpretados como curingas SQL sem controle.

---

## Carrinho

Os itens adicionados ao carrinho são representados pelo relacionamento entre
três modelos:

```text
Car -> LineItem -> Produto
```

### Carrinhos e sessões

O método privado `current_car`, em [ApplicationController](app/controllers/application_controller.rb),
faz o seguinte:

1. procura um carrinho pelo ID salvo em `session[:car_id]`;
2. cria um novo carrinho quando o ID não existe ou não é válido;
3. guarda o novo ID na sessão do navegador.

```ruby
private def current_car
  @current_car ||= Car.find_by(id: session[:car_id]) ||
                   Car.create.tap { |car| session[:car_id] = car.id }
end
```

Isso não representa um usuário autenticado: representa o carrinho associado à
sessão atual. A sessão é fornecida pelo Rails, sem uma gem adicional.

### Itens do carrinho

O controller [LineItemsController](app/controllers/line_items_controller.rb)
recebe o produto e a quantidade:

- `create` procura ou cria um item do carrinho atual;
- quando o produto já existe, soma as unidades;
- quando o produto ainda não existe, cria um novo item;
- `update` altera a quantidade ou remove o item quando recebe zero;
- `destroy` remove o item diretamente.

O modelo `LineItem` valida quantidade inteira maior que zero:

```ruby
validates :quantidade, numericality: { only_integer: true, greater_than: 0 }
```

Um item não fica com quantidade zero no banco: nesse caso ele é excluído.

### Cálculos do carrinho

Em [LineItem](app/models/line_item.rb):

```ruby
def subtotal
  produto.preco * quantidade
end
```

Em [Car](app/models/car.rb):

```ruby
def subtotal
  line_items.includes(:produto).sum { |item| item.subtotal }
end

def total
  subtotal + FRETE_FIXO
end
```

O frete está fixado em `R$ 5,00`. Ele é definido como constante Ruby no back-end
e usado nos cálculos da aplicação.

---

## Pedidos

Ao finalizar o pedido, o usuário envia os dados:

- nome;
- CPF;
- e-mail;
- endereço;
- forma de pagamento.

O model [Pedido](app/models/pedido.rb) valida presença, forma de pagamento e
CPF. Neste momento, os status permitidos pelo código são `criado` e `cancelado`.

### Junção entre carrinho e pedido

No método `PedidosController#create`:

1. o carrinho atual é recuperado pela sessão;
2. o total é calculado no back-end;
3. o pedido é criado;
4. os `LineItem` do carrinho recebem o `pedido_id`;
5. o ID do carrinho é removido da sessão.

Isso permite que um mesmo tipo de item tenha duas referências:

- `car_id`, enquanto pertence ao carrinho;
- `pedido_id`, depois da finalização.

A associação de pedido é opcional no modelo porque o item começa relacionado
somente ao carrinho:

```ruby
belongs_to :pedido, optional: true
```

### Validação de CPF

O [CpfValidator](app/validators/cpf_validator.rb) implementa um validador
personalizado do Rails:

```ruby
class CpfValidator < ActiveModel::EachValidator
```

O validador:

- remove caracteres não numéricos;
- rejeita CPF com quantidade diferente de 11 dígitos;
- rejeita sequências repetidas;
- calcula os dois dígitos verificadores;
- adiciona `cpf é inválido` às mensagens de erro quando necessário.

Não foi necessária uma gem específica para validar CPF. Os dados são normalizados
para apenas números antes da persistência.

---

## API JSON

A pesquisa é uma API JSON acessível pelo prefixo `/produtos/buscar`.

As respostas são construídas com Jbuilder, que cria a chave `imagens`. Cada
imagem recebe uma URL gerada por:

```ruby
url_for(imagem)
```

Principais rotas da aplicação:

```text
GET    /catalogo
GET    /catalogo/:id
GET    /produtos/buscar.json?q=termo
GET    /carrinho
POST   /carrinho/itens
PATCH  /carrinho/itens/:id
DELETE /carrinho/itens/:id
POST   /pedidos
GET    /pedidos/:id
```

---

## Banco de dados inicial

Os dados de exemplo são criados por [db/seeds.rb](db/seeds.rb) usando
`find_or_initialize_by`. Dessa forma, executar o seed novamente atualiza o
produto encontrado ou o cria caso ele ainda não exista.

Para preparar tabelas a partir das migrations:

```bash
bin/rails db:migrate
```

Para preparar o banco e executar os dados iniciais:

```bash
bin/rails db:prepare
bin/rails db:seed
```

---

## Gems principais

| Gem | Uso |
| --- | --- |
| `rails` | framework MVC, Active Record, validações, sessões e rotas |
| `pg` | comunicação da aplicação com PostgreSQL |
| `propshaft` | entrega dos arquivos estáticos |
| `jsbundling-rails` | integração com esbuild |
| `jbuilder` | construção das respostas JSON |
| `turbo-rails` | navegação e respostas HTML |
| `stimulus-rails` | organização opcional de JavaScript por controllers |
| `image_processing` | processamento e manipulação de imagens |

`kt-paperclip` também está declarada no `Gemfile`, mas a implementação atual
dos produtos usa Active Storage, não Paperclip.

---

## Testes

```bash
bin/rails test
```

Os testes cobrem modelos, controllers e regras da aplicação.

Para verificar o carregamento das classes e constantes:

```bash
bin/rails zeitwerk:check
```

Para verificar o código Ruby com RuboCop:

```bash
bin/rubocop
```

---

## Documentação consultada

- [Ruby on Rails Guides — Active Storage](https://guides.rubyonrails.org/active_storage_overview.html)
- [Ruby on Rails Guides — Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)
- [Ruby on Rails Guides — Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
- [Ruby on Rails Guides — Routing](https://guides.rubyonrails.org/routing.html)
- [Ruby on Rails Guides — Sessions](https://guides.rubyonrails.org/action_controller_overview.html#session)
- [Ruby on Rails Guides — Jbuilder](https://github.com/rails/jbuilder)
- [PostgreSQL Documentation — Pattern Matching](https://www.postgresql.org/docs/current/functions-matching.html)
- [esbuild Documentation](https://esbuild.github.io/)

## Vídeos consultados

- [Vídeo sobre desenvolvimento da aplicação Rails](https://www.youtube.com/watch?v=dtfH5h0uc6Y&list=PLHFP2OPUpCeZcPutT9yn4-e0bMmrn5Gd1&index=5)
- [Vídeo de apoio para implementação e estudo](https://www.youtube.com/watch?v=R_LSbReOJHU)
