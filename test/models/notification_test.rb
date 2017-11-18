# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  access_request_id :integer
#  title             :string
#  content           :string
#  status            :integer          default("pending")
#  seen_date         :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "Notification should have default value of email_realtime and as soon as creating notificaiton it will send the email" do
     n = Notification.new
     n.user = users(:one)
     n.title = 'test'
     n.content = 'test'
     assert n.save, n.errors.messages
     n.reload
     assert_equal 'email_sent', n.status
  end

  test 'send_daily_digest should send all notifications in one email' do
    u = users(:test_user)
    u.notification_type = :email_daily_digest
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
    ActionMailer::Base.deliveries.clear
    assert_equal 0, ActionMailer::Base.deliveries.count
    perform_enqueued_jobs do
      Notification.send_daily_digest
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

  test 'send_weekly_digest should send all notifications in one email' do
    u = users(:test_user)
    u.notification_type = :email_weekly_digest
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
    ActionMailer::Base.deliveries.clear
    assert_equal 0, ActionMailer::Base.deliveries.count
    perform_enqueued_jobs do
      Notification.send_weekly_digest
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
