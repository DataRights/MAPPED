# ruby encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin1 = User.find_by email: 'mm.mani@gmail.com'

NotificationSetting.find_or_create_by!(name: 'Web Notification', notification_type: 'web_notification')
NotificationSetting.find_or_create_by!(name: 'Email Instantly', notification_type: 'email_instantly')
NotificationSetting.find_or_create_by!(name: 'Email Daily Digest', notification_type: 'email_daily_digest')
NotificationSetting.find_or_create_by!(name: 'Email Weekly Digest', notification_type: 'email_weekly_digest')


unless admin1
  User.create!(email: 'mm.mani@gmail.com', password_confirmation: 'eybaba13', password: 'eybaba13', approved: true)
  admin1 = User.find_by email: 'mm.mani@gmail.com'
  admin1.confirm
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


sec = Sector.find_or_create_by(name: 'Others')
org = Organization.find_or_create_by(name: 'Example Organization', sector: sec, approved: true)

Setting.find_or_create_by!(key: 'auto_approved_user_domains', value: '*', description: 'Comma seperated list of domains that do not need any admin approval for sign up. * means all domains are allowed and auto approved.')

# Seed the simplest of all workflows (no timeout, evaluation, delete) and one campign
WorkflowStateForm.find_or_create_by!(name: 'Blank State Form', form_path: 'access_requests/templates/state_forms/empty')
WorkflowStateForm.find_or_create_by!(name: 'Evaluate State From', form_path: 'access_requests/templates/state_forms/evaluation')
WorkflowStateForm.find_or_create_by!(name: 'Timeout State Form', form_path: 'access_requests/templates/state_forms/timeout_state')
wsfd = WorkflowStateForm.find_or_create_by!(name: 'Default State Form', form_path: 'access_requests/templates/state_forms/update_status')
WorkflowStateForm.find_or_create_by!(name: 'Dual Transition State Form', form_path: 'access_requests/templates/state_forms/what_happened_update_status')

wtt = WorkflowType.find_or_create_by(name: 'Workflow Simple')
wtv = WorkflowTypeVersion.find_or_create_by(name: 'Workflow Simple Active', workflow_type: wtt, version: 1)

ws0 = WorkflowState.find_or_create_by(name: 'New Request', workflow_type_version: wtv, is_initial_state: true, workflow_state_form: wsfd, button_text: 'CREATE', button_css_class: 'btn btn-warning')
ws1 = WorkflowState.find_or_create_by(name: 'Waiting for sending the AR', workflow_type_version: wtv, workflow_state_form: wsfd, button_text: 'To Send', button_css_class: 'btn btn-warning')
ws2 = WorkflowState.find_or_create_by(name: 'Waiting for Organization', workflow_type_version: wtv, workflow_state_form: wsfd, button_text: 'Waiting', button_css_class: 'btn btn-primary')
ws3 = WorkflowState.find_or_create_by(name: 'Waiting for User Response', workflow_type_version: wtv, workflow_state_form: wsfd, button_text: 'Action Needed', button_css_class: 'btn btn-warning')
ws4 = WorkflowState.find_or_create_by(name: 'Finished', workflow_type_version: wtv, workflow_state_form: wsfd, button_text: 'Finished', button_css_class: 'btn btn-default')

Transition.find_or_create_by(name: 'Access Request Created', history_description: 'Request created', from_state: ws0, to_state: ws1, ui_form: 'empty', transition_type: 'initial', is_initial_transition: true)
Transition.find_or_create_by(name: 'I have sent the request', history_description: 'Request sent', from_state: ws1, to_state: ws2, ui_form: 'access_request_date', transition_type: 'event')
Transition.find_or_create_by(name: 'The organization has responded or called me', history_description: 'Incoming', from_state: ws2, to_state: ws3, ui_form: 'receive_correspondence', transition_type: 'event')
Transition.find_or_create_by(name: "I'd like to send them a reminder (or I have sent one)", history_description: 'Reminder sent', from_state: ws2, to_state: ws2, ui_form: 'send_correspondence', transition_type: 'event')
Transition.find_or_create_by(name: 'I have abandoned the request', history_description: 'Request abandoned', from_state: ws2, to_state: ws4, ui_form: 'empty', transition_type: 'event')
Transition.find_or_create_by(name: "Something else", from_state: ws2, to_state: ws3, ui_form: 'empty', transition_type: 'event')
Transition.find_or_create_by(name: "I'd like to compose an email response", history_description: 'Outgoing', from_state: ws3, to_state: ws2, ui_form: 'empty', transition_type: 'event')
Transition.find_or_create_by(name: "I have already contacted them (or I will soon)", from_state: ws3, to_state: ws2, ui_form: 'send_correspondence', transition_type: 'event')
Transition.find_or_create_by(name: 'The organization contacted again / offered data via their tool', history_description: 'Incoming', from_state: ws3, to_state: ws3, ui_form: 'receive_correspondence', transition_type: 'event')
# Transition.find_or_create_by(name: "I got data with their download tool", history_description: 'Download tool', from_state: ws3, to_state: ws3, ui_form: 'receive_correspondence', transition_type: 'event')
Transition.find_or_create_by(name: "I'm DONE with this request (answer is final or pursued enough)", history_description: 'Request done', from_state: ws3, to_state: ws4, ui_form: 'empty', transition_type: 'event')
Transition.find_or_create_by(name: 'Go back to waiting', history_description: 'Waiting', from_state: ws3, to_state: ws2, ui_form: 'empty', transition_type: 'event')

wtv.active = true
wtv.save!
camp = Campaign.find_or_create_by(name: 'Campaign 2018', workflow_type: wtt)
# also template.

org.campaigns << camp
org.save!

# Seed countries from another file
load File.join(Rails.root, 'db', 'seed_countries.rb')
