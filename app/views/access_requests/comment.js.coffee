<% if @result == 'success' %>
$('#comment_alert<%= @access_request.id %>').hide()
$('#comment_success<%= @access_request.id %>').show()
ok = "<%= t('access_requests.templates.history_comments.comment_success') %>"
$('#comment_success_message<%= @access_request.id %>').html(ok)
$('#send_comment_<%= @access_request.id %>').hide()
<% else %>
$('#comment_success<%= @access_request.id %>').hide()
$('#comment_alert<%= @access_request.id %>').show()
$('#comment_alert_message<%= @access_request.id %>').html "<%= @result %>"
<% end %>
