Rails.application.routes.draw do
  get 'access_requests/index'

  get 'access_requests/new'

  get 'access_requests/create'

  get 'campaigns', to: 'campaigns#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  get 'workflow/diagram/:id', to: 'workflow#diagram'

  get 'users/profile/edit', to: 'users#edit'
  match 'users/profile', to: 'users#update', via: [:patch, :put]
  get 'users/tfa'
  post 'users/enable_otp'
  post 'users/disable_otp'

  root 'home#index'
  get 'home', to: 'home#index'

  resources :attachments
  get 'attachments/:id/content', to: 'attachments#get_content', as: 'get_content'
  post 'attachments/:id/content', to: 'attachments#post_content', as: 'post_content'
  post 'attachments/content/:workflow_transition_id', to: 'attachments#new_content', as: 'new_content'

  get 'attachments/:id/thumbnail', to: 'attachments#thumbnail', as: 'thumbnail'
end
