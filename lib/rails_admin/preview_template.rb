module RailsAdmin
  module Config
    module Actions
      class PreviewTemplate < RailsAdmin::Config::Actions::Base
        # This ensures the action only shows up for TemplateVersions
        register_instance_option :visible? do
          authorized? && bindings[:object].class == TemplateVersion
        end

        # We want the action on members, not the TemplateVersions collection
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end

        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
