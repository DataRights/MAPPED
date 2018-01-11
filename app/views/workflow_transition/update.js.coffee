<% if @status == 'success' %>
$('#modal_edit<%= @a.id %>').modal('hide')
#$('#remarks_update<%= @a.id %>').hide()
#$('#update_transition_success<%= @a.id %>').show()
#$('#update_success_message<%= @a.id %>').html "<%= t('access_requests.templates.history_comments.update_remarks_success') %>"
#$('#update_transition_alert<%= @a.id %>').hide()
<% else %>
$('#update_transition_success<%= @a.id %>').hide()
$('#update_transition_alert<%= @a.id %>').show()
$('#update_alert_message<%= @a.id %>').html "<%= t('access_requests.templates.history_comments.update_remarks_error', status: @status) %>"
<% end %>
