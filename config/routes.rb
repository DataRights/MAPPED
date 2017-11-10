Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  get 'workflow/diagram/:id', to: 'workflow#diagram'
  get 'users/tfa'
  post 'users/enable_otp'
  post 'users/disable_otp'

  root 'home#index'
end
