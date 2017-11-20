desc "This tasks are called by the Heroku scheduler add-on"

task :send_daily_digest => :environment do
  Notification.send_daily_digest
end

task :send_weekly_digest => :environment do
  if Date.today.wday.zero?
    Notification.send_weekly_digest
  end
end
