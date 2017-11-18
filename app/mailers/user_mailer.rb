class UserMailer < ApplicationMailer
  def notification(to, subject, body)
    @body = body
    mail(to: to, subject: subject)
  end

  def digest_notification(to, notifications)
    @notifications = JSON.parse(notifications)
    mail(to: to, subject: I18n.t('notificaitons.diget_email_subject'))
  end
end
