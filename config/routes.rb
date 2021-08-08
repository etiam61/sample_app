Rails.application.routes.draw do
  scope "(:locale)", locale: /en/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/contact", to: "static_pages#contact"
    get "/about", to: "static_pages#about"
    get "/login", to: "sessions#new"
    post "/login", to:"sessions#create"
    delete "/logout", to:"sessions#destroy"
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :microposts, only: %i(create destroy)
    resources :users do
      member do
        resources :followings, only: :index
        resources :followers, only: :index
      end
    end
    resources :relationships, only: %i(create destroy)
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
