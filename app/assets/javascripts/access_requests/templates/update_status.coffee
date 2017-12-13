$(document).on "turbolinks:load", ->
  $("#update_status_save").on("ajax:success", (e, data, status, xhr) ->
    $("#result").val 'Success'
  ).on "ajax:error", (e, xhr, status, error) ->
    $("#result").val "ERROR"
