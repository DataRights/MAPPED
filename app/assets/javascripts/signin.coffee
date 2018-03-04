$(document).on "turbolinks:load", ->
  $('#user_email').on 'change', ->
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
