Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "welcome#index"

  post "/", to: "welcome#create", as: :demo

  get "register", to: "users#new"
  post "register", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  delete "logout", to: "sessions#destroy"

  get "password", to:"passwords#edit", as: :edit_password
  patch "password", to:"passwords#update"

  get "password/reset", to: "password_resets#new"
  post "password/reset", to: "password_resets#create"

  get "password/reset/edit", to: "password_resets#edit"
  patch "password/reset/edit", to: "password_resets#update"

  resources :plants
  #get "my_plants/:id"
  #delete "my_plants/:id"

  get "me", to: "users#show"

  get "email", to:"users#edit_email", as: :edit_email
  patch "email", to:"users#update_email"

  get "address", to:"users#edit_address", as: :edit_address
  patch "address", to:"users#update_address"

  delete "delete", to:"users#destroy", as: :delete_user

end
