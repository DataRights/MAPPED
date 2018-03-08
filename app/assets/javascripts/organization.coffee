# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Used in new access request page for add organization modal
$(document).on "turbolinks:load", ->
  $('#addOrganizationModal').on 'hidden.bs.modal', ->
    others = 'Others'
    exists = false
    $('#access_request_sector_id option').each ->
      if this.text == others
        exists = true
        this.selected = true
        $('#access_request_sector_id').val(this.value).trigger('change')
        return false # breaks each loop

    url = window.location.toString()
    Turbolinks.visit(url, {action: 'replace'}) unless exists
