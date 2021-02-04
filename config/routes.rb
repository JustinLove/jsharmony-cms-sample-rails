Rails.application.routes.draw do
  root "random_numbers#index"

  get "/random_numbers", to: "random_numbers#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
