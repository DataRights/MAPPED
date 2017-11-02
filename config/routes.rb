Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  get 'users/tfa'
  post 'users/enable_otp'
  post 'users/disable_otp'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'rails_admin/main#dashboard'
end
