check_otp = () ->
  url = '/user/has_otp?email=' + $('#user_email').val()
  $.ajax url,
    type: 'GET',
    contentType: "application/json;charset=utf-8",
    dataType: 'json',
    success: (e) ->
      console.log e
      if e
        $('#otp_fields').collapse('show')
      else
        $('#otp_fields').collapse('hide')

$(document).on "turbolinks:load", ->

  if $('#user_email').val() != ''
    check_otp()

  $('#user_email').on 'change', ->
    check_otp()
