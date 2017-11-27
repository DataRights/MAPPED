class Users::InvitationsController < Devise::InvitationsController
  before_action :check_admin

  def create
    if params[:customized_invitation]
      user = User.invite!(:email => params[:user][:email], :skip_invitation => true)
      user.send(:generate_invitation_token!)
      mail_content = params[:customized_invitation_content].gsub('$ACCEPT_INVITATION_URL$',Rails.application.routes.url_helpers.accept_user_invitation_url(:host => Rails.configuration.base_url, :invitation_token => user.raw_invitation_token))
      UserMailer.custom_invitation(user,mail_content).deliver
      user.invitation_sent_at = DateTime.now
      user.save!
      redirect_to root_path
    else
      super
    end
  end

  private

  def check_admin
    #TODO: Only allow admin send invitations
    #for now everybody should be able to send invite(to its freinds)!
    #redirect_to root_path unless current_user.admin?
  end
end
