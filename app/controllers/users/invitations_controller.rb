class Users::InvitationsController < Devise::InvitationsController
  before_action :check_admin

  def create
    if params[:customized_invitation]
      user = User.invite!(:email => params[:user][:email], :skip_invitation => true)
      UserMailer.custom_invitation(user,params[:customized_invitation_content]).deliver
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
