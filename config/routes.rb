Rails.application.routes.draw do
  # 共通
  root "sessions#new"
  delete 'logout'  => 'sessions#destroy'

  # 顧客
  get    'mypage'  => 'customers#show'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  resources :customers, only: %i[new create]
  resources :appoints, only: %i[index show new create destroy]

  # 社員
  get    'staffs/mypage'  => 'staffs#mypage'
  get    'staffs/login'   => 'sessions#new_staff'
  post   'staffs/login'   => 'sessions#create_staff'
  resources :staffs, only: %i[index show new create]
  resources :staff_appoint_frames, only: %i[index]
end
