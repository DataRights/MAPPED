require 'single_sign_on'

class DiscourseSsoController < ApplicationController
  before_action :authenticate_user! # ensures user must login

  def sso
    sso = SingleSignOn.parse(request.query_string, ENV['DISCOURSE_SSO_SECRET'])
    sso.email = current_user.email # from devise
    sso.name = current_user.full_name # this is a custom method on the User class
    sso.username = current_user.email # from devise
    sso.external_id = current_user.id # from devise
    sso.sso_secret = ENV['DISCOURSE_SSO_SECRET']

    redirect_to sso.to_url("#{Rails.configuration.discourse_server}/session/sso_login")
  end
end
