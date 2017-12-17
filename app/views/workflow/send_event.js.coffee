<% if @workflow_transition.status == 'success' %>
$('#send_event_alert<%= @ar.id %>').hide()
$('#send_event_success<%= @ar.id %>').show()
$('#success_message<%= @ar.id %>').html "<%= t('workflow.send_event_success') %>"
$('#update_status_save<%= @ar.id %>').hide()
<% else %>
$('#send_event_success<%= @ar.id %>').hide()
$('#send_event_alert<%= @ar.id %>').show()
$('#alert_message<%= @ar.id %>').html '<%= "#{@workflow_transition.action_failed_message} - #{@workflow_transition.failed_guard_message}" %>'
<% end %>
