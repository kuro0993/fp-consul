Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # get "/customer/appoint", to: "appoint#index"
  # get "/customer/appoint/new", to: "appoint#new"

  # resource :customer
  # resource :staff
  # namespace :staff do
  #   resources :appoints, only: [:index, :new, :create]
  # end
  resources :appoints, only: [:index, :new, :create]

end
