Rails.application.routes.draw do
  root "random_numbers#index"

  get "/random_numbers", to: "random_numbers#index"

  get "/cms_templates/*template", to: "cms_templates#index"

  get "/login", to: "cms_test_cases#login"
  get "/standalone_onecolumn", to: "cms_test_cases#standalone_onecolumn"
  get "/standalone_twocolumn", to: "cms_test_cases#standalone_twocolumn"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
