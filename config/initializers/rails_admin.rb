    require Rails.root.join('lib', 'rails_admin', 'preview_template.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::PreviewTemplate)

RailsAdmin.config do |config|

  config.main_app_name = ["DataInSight", "Dashboard"]

  config.navigation_static_label = "Tools"
  config.navigation_static_links = {
    'Two Factor authentication' => '/users/tfa',
    'Invitition' => '/users/invitation/new',
    'Sidekiq Jobs' => '/sidekiq'
  }

  # showing id field
  config.default_hidden_fields = []

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
  config.show_gravatar = false  # HA

  config.label_methods << :description
  config.label_methods << :email
  config.label_methods << :action
  config.label_methods << :line1
  config.label_methods << :role
  config.label_methods << :admin_login
  config.label_methods << :name
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


  config.excluded_models = ["Blazer::Audit", "Blazer::Check", "Blazer::Dashboard", "Blazer::DashboardQuery", "Blazer::Query",
      "Event", "Role", "CodeAction", "WorkflowStateForm", "AccessRight",
      "NotificationSetting", "EmailNotification", "WebNotification"]


  ####################################################################
  #                     BEGIN TOP MENU ITEMS
  ####################################################################

  config.model AccessRequest do
    navigation_label 'Access Requests'
    weight 1
  end

  config.model User do
    navigation_label 'User Management'
    weight 10
    #exclude_fields :user_roles, :answers, :notifications

    create do
      field :email
      field :password
      field :password_confirmation
      field :otp_required_for_login
      field :first_name
      field :last_name
      field :preferred_language
      field :approved
      field :roles
      field :notification_settings
    end

    edit do
      field :email
      field :password
      field :password_confirmation
      field :otp_required_for_login
      field :first_name
      field :last_name
      field :preferred_language
      field :approved
      field :roles
      field :notification_settings
    end

    list do
      field :email
      field :otp_required_for_login
      field :first_name
      field :last_name
      field :preferred_language
      field :approved
      field :sign_in_count
      field :last_sign_in_at
      field :confirmed_at
      field :failed_attempts
      field :roles
      field :notification_settings
    end

  end

  config.model Sector do
    navigation_label 'Organization Management'
    weight 20
  end

  config.model Question do
    navigation_label 'Survey Management'
    weight 40
  end

  config.model Campaign do
      navigation_label 'Campaign Settings'
      weight 50

    create do
      field :name
      field :short_description
      field :expanded_description
      field :policy_consent
      field :workflow_type
      field :organizations
      field :questions
    end

    edit do
      field :name
      field :short_description
      field :expanded_description
      field :policy_consent
      field :workflow_type
      field :organizations
      field :questions
    end

    list do
      field :name
      field :short_description
      field :expanded_description
      field :policy_consent
      field :workflow_type
      field :organizations
      field :questions
    end
  end


  config.model Setting do
    navigation_label 'Platform Settings'
    weight 70
  end


  ####################################################################
  #                     END TOP MENU ITEMS
  ####################################################################

  config.model Notification do
    #navigation_label 'Notification Management'
    #weight 30
    parent User
  end

  config.model AccessRequestStep do
    parent AccessRequest
  end

  config.model Workflow do
    parent AccessRequest
  end

  config.model Comment do
    parent AccessRequest
  end

  config.model UserRole do
    parent User
  end

  # config.model AccessRight do
  #   parent Setting
  # end

  config.model Address do
      label "Entered Addresses"
     parent Sector
  end

  # config.model Role do
  #   parent User
  # end

  config.model Country do
    parent Setting
    edit do
      field :name
      field :languages, :pg_string_array
    end
  end


  config.model WorkflowType do
    parent Campaign

  end

  config.model WorkflowTypeVersion do
      parent Campaign


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

  config.model Template do
      parent Campaign

    create do
      field :name
      field :template_type
      field :sectors
      field :version
      field :content, :ck_editor
      field :active
      field :language
    end

    edit do
      field :name
      field :template_type
      field :sectors
      field :version
      field :content, :ck_editor
      field :active
      field :language
    end

    list do
      field :id
      field :name
      field :template_type
      field :sectors
      field :version
      field :active
      field :language
    end
  end

  config.model Answer do
    parent Question
  end

  # config.model Event do
  #   parent Campaign
  # end

  # config.model Guard do
  #   parent Campaign
  # end

  config.model Correspondence do
    parent AccessRequest
  end


  config.model WorkflowState do
    parent Campaign
  end

  config.model Transition do
    parent Campaign

    create do
      field :name
      field :history_description
      field :from_state
      field :to_state
      field :timeout_days
      field :ui_form
      field :transition_type
      field :display_order
      field :actions
      #HA field :guards
    end

    edit do
      field :name
      field :history_description
      field :from_state
      field :to_state
      field :timeout_days
      field :transition_type
      field :ui_form
      field :display_order
      field :actions
      #HA field :guards
    end
  end

  # config.model CodeAction do
  #   parent Campaign
  #   label "Action"
  #   label_plural "Actions"
  # end


  config.model Organization do
    parent Sector
    list do
      field :name
      field :sector
      field :approved
      field :suggested_by_user
      field :custom_1
      field :custom_1_desc
      field :custom_2
      field :custom_2_desc
      field :custom_3
      field :custom_3_desc
      field :address
      field :campaigns
      #HA field :tags
      field :languages, :pg_string_array
    end

    create do
      field :name
      field :sector
      field :approved
      field :suggested_by_user
      #field :custom_1
      #field :custom_1_desc
      #field :custom_2
      #field :custom_2_desc
      #field :custom_3
      #field :custom_3_desc
      field :address
      field :campaigns
      #HA field :tags
      field :remark
      field :languages, :pg_string_array
    end

    edit do
      field :name
      field :sector
      field :approved
      field :suggested_by_user
      #field :custom_1
      #field :custom_1_desc
      #field :custom_2
      #field :custom_2_desc
      #field :custom_3
      #field :custom_3_desc
      field :address
      field :campaigns
      #HA field :tags
      field :remark
      field :languages, :pg_string_array
    end
  end

  # config.model EmailNotification do
  #   parent User
  # end
  #
  # config.model WebNotification do
  #   parent User
  # end

  # config.model NotificationSetting do
  #   parent Notification
  # end

  config.model Attachment do
    parent AccessRequest
  end

  #HA
  # config.model Tag do
  #   parent Comment
  # end

  config.model PolicyConsent do
    parent Campaign
  end

  config.model UserPolicyConsent do
    parent User
  end


end
