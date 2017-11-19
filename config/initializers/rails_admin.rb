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
    if current_user.nil?
      warden.authenticate! scope: :user
    else
      redirect_to main_app.root_path unless current_user.can?(:admin_login)
    end
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
  config.label_methods << :role
  config.label_methods << :admin_login

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
