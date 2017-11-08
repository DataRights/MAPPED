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

        register_instance_option :controller do
          proc do
            @campaign_id = params[:campaign_id] ? params[:campaign_id].to_i : -1
            @user_id = params[:user_id] ? params[:user_id].to_i : -1
            @organization_id = params[:organization_id] ? params[:organization_id].to_i : -1

            @campaigns = Campaign.all.map { |campaign| [campaign.name, campaign.id] }
            @campaigns.insert(0,['Select a Campaign', -1])
            @selected_campain = @campaigns.index {|c| c[1] == @campaign_id}
            @selected_campain ||= 0

            @users = User.all.map { |user| [user.email, user.id] }
            @users.insert(0,['Select a User', -1])
            @selected_user = @users.index {|u| u[1] == @user_id}
            @selected_user ||= 0

            @organizations = Organization.all.map { |organization| [organization.name, organization.id] }
            @organizations.insert(0,['Select an Organization', -1])
            @selected_organization = @organizations.index {|o| o[1] == @organization_id}
            @selected_organization ||= 0

            context = TemplateContext.new
            context.campaign = Campaign.find_by_id(@campaign_id) unless  @selected_campain == 0
            context.user = User.find_by_id(@user_id) unless  @selected_user == 0
            context.organizations = Organization.find_by_id(@organizations_id) unless  @selected_organization == 0

            @rendered_template = @object.render(context)

            if params[:commit] == 'PDF'
              send_data(WickedPdf.new.pdf_from_string(@rendered_template) , :type => :pdf, :disposition => 'inline')
            else
              render action: @action.template_name
            end
          end
        end
      end
    end
  end
end
