$(document).on "turbolinks:load", ->
  $('[data-toggle="popover"]').popover()
  $('li.active').removeClass('active')
  $('a[href="' + location.pathname + '"]').closest('li').addClass('active')

ready = ->
  $('.ckeditor').each ->
    CKEDITOR.replace $(this).attr('id')

$(document).ready(ready)
$(document).on('page:load', ready)
