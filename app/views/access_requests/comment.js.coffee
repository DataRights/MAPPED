<% if @result == 'success' %>
$('#comment_alert<%= @ar.id %>').hide()
$('#comment_success<%= @ar.id %>').show()
$('#comment_success_message<%= @ar.id %>').html "<%= t('access_requests.templates.history_comments.comment_success') %>"
$('#send_comment_<%= @ar.id %>').hide()
<% else %>
$('#comment_success<%= @ar.id %>').hide()
$('#comment_alert<%= @ar.id %>').show()
$('#comment_alert_message<%= @ar.id %>').html "<%= @result %>"
<% end %>
