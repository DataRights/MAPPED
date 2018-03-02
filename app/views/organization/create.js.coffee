<% if @result == 'success' %>
Cookies.set('organization', '<%= @o.id %>');
$('#addOrganizationModal').modal('hide')
<% else %>
$('#add_organization_alert').show()
$('#alert_message_add_organization').html '<%= @result %>'
<% end %>
