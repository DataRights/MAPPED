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
    parent Template
    edit do
      field :version
      field :template
      field :content, :ck_editor
      field :active
      field :language
    end
  end

  config.model WorkflowTypeVersion do
    list do
      field :version
      field :workflow_type
      field :active

      field :diagram do
        pretty_value do
          %{<a id="workflow_diagram_link" href="/workflow/diagram/#{value}" target='_blank'>#{I18n.t('workflow.generate_diagram')}</a>}.html_safe
        end
      end
    end
  end

  config.model Answer do
    parent Question
  end

  config.model UserRole do
    parent User
  end

  config.model AccessRight do
    parent User
  end

  config.model Notification do
    parent User
  end

  config.model Address do
    parent User
  end

  config.model Role do
    parent User
  end

  config.model City do
    parent User
  end

  config.model Country do
    parent User
  end

  config.model WorkflowState do
    parent Workflow
  end

  config.model WorkflowTransition do
    parent Workflow
  end

  config.model WorkflowType do
    parent Workflow
  end

  config.model WorkflowTypeVersion do
    parent Workflow
  end

  config.model WorkflowState do
    parent Workflow
  end

  config.model Transition do
    parent Workflow
  end

  config.model Guard do
    parent Workflow
  end

  config.model CodeAction do
    parent Workflow
  end

  config.model Organization do
    parent Sector
  end

end
