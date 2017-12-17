require Rails.root.join('lib', 'rails_admin', 'preview_template.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::PreviewTemplate)

RailsAdmin.config do |config|

  config.main_app_name = ["MAPPED", "Dashboard"]

  config.navigation_static_label = "Tools"
  config.navigation_static_links = {
    'Two Factor authentication' => '/users/tfa',
    'Invitition' => '/users/invitation/new'
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

  config.label_methods << :description
  config.label_methods << :email
  config.label_methods << :action
  config.label_methods << :line1
  config.label_methods << :role
  config.label_methods << :admin_login
  config.label_methods << :name

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

  config.model AccessRequest do
    navigation_label 'Access Requests & Workflows'
    weight 0
  end

  config.model User do
    navigation_label 'User Management'
    weight 1
    exclude_fields :user_roles, :answers, :notifications
  end

  config.model Template do
    navigation_label 'Template Engine'
    weight 2
  end

  config.model Sector do
    navigation_label 'Sectors & Organizations'
    weight 3
  end

  config.model Question do
    navigation_label 'Survey'
    weight 4
  end

  config.model Notification do
    navigation_label 'Notification Engine'
    weight 5
  end

  config.model Comment do
    navigation_label 'General'
    weight 6
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
      field :name
      field :workflow_type
      field :version
      field :active

      field :diagram do
        pretty_value do
          %{<a id="workflow_diagram_link" href="/workflow/diagram/#{value}" target='_blank'>#{I18n.t('workflow.generate_diagram')}</a>}.html_safe
        end
      end
    end

    create do
      field :name
      field :workflow_type
      field :version
      field :active
    end

    edit do
      field :name
      field :workflow_type
      field :version
      field :active
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
    parent AccessRequest
  end

  config.model WorkflowTransition do
    parent AccessRequest
  end

  config.model WorkflowType do
    parent AccessRequest
  end

  config.model WorkflowTypeVersion do
    parent AccessRequest
  end

  config.model WorkflowState do
    parent AccessRequest
  end

  config.model WorkflowStateForm do
    parent AccessRequest
  end

  config.model Transition do
    parent AccessRequest
  end

  config.model Guard do
    parent AccessRequest
  end

  config.model Workflow do
    parent AccessRequest
  end

  config.model CodeAction do
    parent AccessRequest
    label "Action"
    label_plural "Actions"
  end

  config.model Campaign do
    parent AccessRequest

    create do
      field :name
      field :short_description
      field :expanded_description
      field :policy_consent
      field :workflow_type
      field :questions
    end

    edit do
      field :name
      field :short_description
      field :expanded_description
      field :policy_consent
      field :workflow_type
      field :questions
    end

    list do
      field :name
      field :short_description
      field :expanded_description
      field :policy_consent
      field :workflow_type
      field :questions
    end
  end

  config.model Organization do
    parent Sector
    list do
      field :name
      field :sector
      field :custom_1
      field :custom_1_desc
      field :custom_2
      field :custom_2_desc
      field :custom_3
      field :custom_3_desc
    end

    create do
      field :name
      field :sector
      field :custom_1
      field :custom_1_desc
      field :custom_2
      field :custom_2_desc
      field :custom_3
      field :custom_3_desc
    end

    edit do
      field :name
      field :sector
      field :custom_1
      field :custom_1_desc
      field :custom_2
      field :custom_2_desc
      field :custom_3
      field :custom_3_desc
    end
  end

  config.model EmailNotification do
    parent Notification
  end

  config.model WebNotification do
    parent Notification
  end

  config.model NotificationSetting do
    parent Notification
  end

  config.model Attachment do
    parent AccessRequest
  end

  config.model Tag do
    parent Comment
  end

  config.model PolicyConsent do
    parent User
  end

  config.model UserPolicyConsent do
    parent User
  end


end
