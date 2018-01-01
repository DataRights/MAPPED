Rails.application.routes.draw do

  get 'letter/:id/download', to: 'letters#download', as: 'download_letter'

  get 'campaign/:campaign_id/access_requests', to: 'access_requests#index', as: 'campaign_access_requests'

  get 'campaign/:campaign_id/access_request/new', to: 'access_requests#new', as: 'campaign_access_request_new'

  post 'access_requests/create'
  get  'access_requests/preview'
  get  'access_request/:id/download', to: 'access_requests#download', as: 'downlaod_access_request'
  post 'access_request/:id/comment', to: 'access_requests#comment', as: 'access_request_comment'

  get 'campaigns', to: 'campaigns#index'
  get 'campaigns/:id/organizations/:sector_id', to: 'campaigns#get_organizations', as: 'get_campaign_organizations'
  get 'campaigns/:id/organizations/:organization_id/template', to: 'campaigns#get_organization_template', as: 'get_campaign_organization_template'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :invitations => 'users/invitations' }

  # Workflow
  get 'workflow/diagram/:id', to: 'workflow#diagram'
  patch 'workflow', to: 'workflow#send_event'
  post 'workflow/undo/:workflow_transition_id', to: 'workflow#undo'

  get 'user/profile/edit', to: 'users#edit'
  get 'user/profile/campaign/:campaign_id', to: 'users#edit', as: 'user_profile_for_campaign'
  match 'users/profile', to: 'users#update', via: [:patch, :put]
  get 'users/tfa'
  post 'users/enable_otp'
  post 'users/disable_otp'

  root 'home#index'
  get 'home', to: 'home#index'

  resources :attachments
  get 'attachments/:id/content', to: 'attachments#get_content', as: 'get_content'
  post 'attachments/:id/content', to: 'attachments#post_content', as: 'post_content'
  post 'attachments/content', to: 'attachments#new_content', as: 'new_content'

  get 'attachments/:id/thumbnail', to: 'attachments#thumbnail', as: 'thumbnail'
end
