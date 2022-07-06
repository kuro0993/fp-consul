Rails.application.routes.draw do
  root "sessions#new"
  resources :appoints, only: %i[index show new create destroy]
  resources :customers, only: %i[show new create]
  get    'mypage'  => 'customers#show'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
end
