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

SendingMethod.find_or_create_by!(name: 'Post')
SendingMethod.find_or_create_by!(name: 'Email')
SendingMethod.find_or_create_by!(name: 'Web Form')
SendingMethod.find_or_create_by!(name: 'Other')


unless admin1
  User.create!(email: 'mm.mani@gmail.com', password_confirmation: 'eybaba13', password: 'eybaba13', approved: true)
  admin1 = User.find_by email: 'mm.mani@gmail.com'
  admin1.confirm
end

unless admin2
  User.create!(email: 'shahriar.b@gmail.com', password_confirmation: 'eybaba13', password: 'eybaba13', approved: true)
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

WorkflowStateForm.find_or_create_by!(name: 'Evaluate Form', form_path: 'access_requests/templates/evaluation')
WorkflowStateForm.find_or_create_by!(name: 'Update Status Form', form_path: 'access_requests/templates/update_status')
WorkflowStateForm.find_or_create_by!(name: 'Awaiting Response', form_path: 'access_requests/templates/awaiting_response')
WorkflowStateForm.find_or_create_by!(name: 'Done', form_path: 'access_requests/templates/done')
WorkflowStateForm.find_or_create_by!(name: 'What Happened? Update Status', form_path: 'access_requests/templates/what_happened_update_status')

Sector.find_or_create_by(name: 'Others')

Setting.find_or_create_by!(key: 'auto_approved_user_domains', value: '*', description: 'Comma seperated list of domains that do not need any admin approval for sign up. * means all domains are allowed and auto approved.')
