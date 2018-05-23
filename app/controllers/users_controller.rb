class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:has_otp]

  def has_otp
    u = User.find_by email: params[:email]
    @has_otp = u&.otp_required_for_login ? true : false
    respond_to do |format|
      format.html
      format.json { render json: @has_otp }
    end
  end

  def disable_otp
    current_user.disable_otp!
    render users_tfa_path
  end

  def enable_otp
    current_user.enable_otp!
    render users_tfa_path
  end

  def tfa
  end

  def edit
    @user = current_user
    @consent = nil
    @campaign_id = nil

    @title = I18n.t('users.edit.title')

    if params.include?(:campaign_id)
      @title = I18n.t('users.edit.title_before_you_start')
      campaign = Campaign.find(params[:campaign_id])
      return unless campaign
      @campaign_id = campaign.id
      pc = campaign.policy_consent
      pc = PolicyConsent.find_by(type_of: :campaign) if pc.nil?
      return unless pc
      @upc = UserPolicyConsent.find_or_create_by user_id: current_user.id, policy_consent_id: pc.id
      if @upc.approved && !current_user.first_name.blank? && !current_user.last_name.blank?
        redirect_to new_campaign_access_request_path(@campaign_id) and return
      end
      tv = Template.find_by id: pc.template_id, active: true
      if tv
        tc = TemplateContext.new
        tc.user = current_user
        @consent = tv.render(tc).html_safe
        if @upc.content.blank?
          @upc.content = @consent
        end
      end
    end
  end

  def update
    current_user.assign_attributes(user_params)
    if current_user.valid? && current_user.update(user_params)
      flash[:success] = I18n.t('users.edit.profile_success')
      redirect_based_on_campaign(current_user.campaign_id, true)
    else
      flash[:alert] = current_user.errors.full_messages.join(". ")
      redirect_based_on_campaign(current_user.campaign_id, false)
    end
  end

  def redirect_based_on_campaign(campaign_id, success)
    unless campaign_id.blank?
      campaign = Campaign.find(campaign_id)
      if success
        redirect_to campaign_access_requests_path(campaign_id) and return
      else
        redirect_to user_profile_for_campaign_path(campaign) and return
      end
    else
      redirect_to user_profile_edit_path
    end
  end

  private

  def policy_consent_params
    params.require(:user_policy_consents).permit(:id, :approved, :content)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :preferred_language, :campaign_id, notification_setting_ids: [], address_attributes: [:line1, :line2, :post_code, :city_name, :country_id], user_policy_consents_attributes:[:id, :approved, :content])
  end
end
