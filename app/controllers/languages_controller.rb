class LanguagesController < ApplicationController
  def set
    I18n.locale = params[:lang]
    cookies[:locale] = I18n.locale
    begin
      redirect_to :back
    rescue
      redirect_to :root
    end
  end
end
