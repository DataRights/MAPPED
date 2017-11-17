desc "This tasks are called by the Heroku scheduler add-on"

task :send_daily_digest => :environment do
  users = User.where(notification_type: :email_daily_digest)
  users.each { |u| u.send_notifications }
end

task :send_weekly_digest => :environment do
  users = User.where(notification_type: :email_weekly_digest)
  users.each { |u| u.send_notifications }
end
