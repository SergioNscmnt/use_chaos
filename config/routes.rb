Rails.application.routes.draw do
  devise_for :usuarios_administrativos,
    path: "administracao",
    path_names: {
      sign_in: "entrar",
      sign_out: "sair",
      password: "senha"
    }

  root "publico/inicio#index"

  scope module: :publico do
    resources :produtos, only: %i[index show], param: :slug do
      resources :avaliacoes, only: :create
    end
    resource :carrinho, only: :show
    resources :itens_carrinho, only: %i[create update destroy]
    resource :checkout, only: %i[new create]
    resources :manifestacoes, only: %i[new create]
  end

  namespace :administracao do
    root "painel#index"
    resource :minha_conta, only: %i[show update], controller: :minha_conta
    resources :categorias, except: :show
    resources :produtos do
      patch :ajustar_estoque, on: :member
    end
    resources :pedidos, only: %i[index show] do
      patch :alterar_situacao, on: :member
    end
    resources :avaliacoes, only: %i[index update]
    resources :manifestacoes, only: %i[index show update]
    resources :relatorios, only: %i[index create show]
    resources :usuarios_administrativos, except: :destroy
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
