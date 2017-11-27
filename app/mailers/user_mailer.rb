class UserMailer < ApplicationMailer
  def notification(email_notification_id)
    e = EmailNotification.find_by id: email_notification_id
    @body = e.notification.content
    begin
      mail(to: e.notification.user.email, subject: e.notification.title)
      e.update_attributes(status: :sent, error_log: nil)
    rescue Exception => ex
      e.update_attributes(status: :failed, error_log: ex.inspect)
    end
  end

  def digest_notification(to, email_notification_ids)
    @email_notifications = EmailNotification.where(id: email_notification_ids)
    begin
      mail(to: to, subject: I18n.t('notificaitons.diget_email_subject'))
      @email_notifications.update_all(status: :sent, error_log: nil)
    rescue Exception => ex
      @email_notifications.update_all(status: :failed, error_log: ex.inspect)
    end
  end

  def custom_invitation(to,custom_text)
    @body = custom_text
    mail(to: to, subject: I18n.t('devise.invitations.new.custom_email_subject'))
  end
end
