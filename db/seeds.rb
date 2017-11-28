# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin1 = User.find_by email: 'mm.mani@gmail.com'
admin2 = User.find_by email: 'shahriar.b@gmail.com'

NotificationSetting.find_or_create_by!(name: 'Web Notification', notification_type: 'web_notification')
NotificationSetting.find_or_create_by!(name: 'Email Instantly', notification_type: 'email_instantly')
NotificationSetting.find_or_create_by!(name: 'Email Daily Digest', notification_type: 'email_daily_digest')
NotificationSetting.find_or_create_by!(name: 'Email Weekly Digest', notification_type: 'email_weekly_digest')

unless admin1
  User.create!(email: 'mm.mani@gmail.com', password_confirmation: 'eybaba13', password: 'eybaba13')
  admin1 = User.find_by email: 'mm.mani@gmail.com'
  admin1.confirm
end

unless admin2
  User.create!(email: 'shahriar.b@gmail.com', password_confirmation: 'eybaba13', password: 'eybaba13')
  admin2 = User.find_by email: 'shahriar.b@gmail.com'
  admin2.confirm
end

admin_role = Role.find_by name: 'admin'
unless admin_role
  Role.create! name: 'admin'
  admin_role = Role.find_by name: 'admin'
  AccessRight.find_or_create_by!(action: 'admin_login', role: admin_role)
end

unless admin1.roles.include?(admin_role)
  admin1.roles << admin_role
  admin1.save!
end

unless admin2.roles.include?(admin_role)
  admin2.roles << admin_role
  admin2.save!
end
