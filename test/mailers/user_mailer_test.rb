require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "digest_notification should send all the pending notifications of a user in one email" do
     u = users(:test_user)
     u.notification_settings << notification_settings(:email_daily)
     assert u.save

     n1 = Notification.new
     n1.title = 'test1_title'
     n1.content = 'test1_content'
     n1.user = u
     assert n1.save

     n2 = Notification.new
     n2.title = 'test2_title'
     n2.content = 'test2_content'
     n2.user = u
     assert n2.save

     notifications = Notification.where(user_id: u.id)
     email_notification_ids = []
     notifications.each { |n| email_notification_ids << n.email_notifications.first.id }

     assert_equal 0, ActionMailer::Base.deliveries.count
     perform_enqueued_jobs do
       UserMailer.digest_notification(u.email, email_notification_ids).deliver_later
       mail = ActionMailer::Base.deliveries.last
       assert mail
       assert_equal [u.email], mail.to, mail.inspect
       assert_equal I18n.t('notificaitons.diget_email_subject'), mail.subject, mail.inspect
       assert mail.body.parts.first.body.raw_source.include?('test1_title')
       assert mail.body.parts.first.body.raw_source.include?('test1_content')
       assert mail.body.parts.first.body.raw_source.include?('test2_title')
       assert mail.body.parts.first.body.raw_source.include?('test2_content')
     end
  end
end
