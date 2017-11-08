require Rails.root.join('lib', 'rails_admin', 'preview_template.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::PreviewTemplate)

RailsAdmin.config do |config|

  config.main_app_name = ["MAPPED", "Admin"]

  config.navigation_static_links = {
    'Two Factor authentication' => '/users/tfa'
  }

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.model 'CodeAction' do
    label "Action"
    label_plural "Actions"
  end

  config.label_methods << :description
  config.label_methods << :email
  config.label_methods << :action
  config.label_methods << :line1
  config.label_methods << :version

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    preview_template
  end

  config.model TemplateVersion do
    edit do
      field :version
      field :template
      field :content, :ck_editor
      field :active
      field :language
    end
  end
end
