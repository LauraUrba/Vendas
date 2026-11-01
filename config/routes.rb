Rails.application.routes.draw do
  get "cars/show"
  get "produtos/buscar", to: "produtos#buscar", as: :buscar_produtos
  resources :produtos
  get "catalogo", to: "catalogo#index", as: :catalogo
  get "catalogo/:id", to: "catalogo#show", as: :catalogo_produto

  get "carrinho", to: "cars#show", as: :carrinho
  resources :line_items, path: "carrinho/itens", only: [:create, :update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  resources :pedidos, only: [:new, :create, :show, :update]

  root "catalogo#index"
end
