getUrl = window.location;
baseUrl = getUrl.protocol + "//" + getUrl.host;

updateTemplateContent = (organization_id) ->
  $.ajax
    url: baseUrl + '/campaigns/' + $('#campaign_id').val() + '/organizations/' + organization_id + '/template'
    type: 'GET'
    success: (e) ->
      document.getElementById('textContentStandard').innerHTML = e.template
      CKEDITOR.instances['custom_text'].setData e.template
      return
  return

window.onclick = (event) ->
  modal = document.getElementById('previewModal')
  if event.target == modal
    modal.style.display = 'none'
  return

$(document).on 'turbolinks:load', ->

  $('#ar_pdf_preview').on 'click', ->
    console.log 'clicked on ar_pdf_preview button'
    rendered_template = ''
    if document.getElementById('textTypeRadioStandard').checked
      rendered_template = document.getElementById('textContentStandard').innerHTML
    else if document.getElementById('textTypeRadioExpanded').checked
      rendered_template = CKEDITOR.instances['custom_text'].getData()
    oReq = new XMLHttpRequest
    oReq.responseType = 'blob'

    oReq.onload = (e) ->
      console.log 'Onload e: ' + e
      console.log 'Creating object url using response: ' + oReq.response
      file = window.URL.createObjectURL(oReq.response)
      PDFJS.disableWorker = true
      PDFJS.getDocument(file).then (pdf) ->
        console.log 'get document returned pdf: ' + pdf
        # Fetch the page.
        pdf.getPage(1).then (page) ->
          console.log 'getPage 1: ' + page
          scale = 1
          viewport = page.getViewport(scale)
          # Prepare canvas using PDF page dimensions.
          canvas = document.getElementById('preview-canvas')
          context = canvas.getContext('2d')
          canvas.height = viewport.height
          canvas.width = viewport.width
          # Render PDF page into canvas context.
          renderContext =
            canvasContext: context
            viewport: viewport
          page.render(renderContext).then ->
            document.getElementById('previewModal').style.display = 'block'
            return
          return
        return
      return

    console.log 'Openning access_requests/preview url with template: ' + encodeURIComponent(rendered_template)
    oReq.open 'GET', baseUrl + '/access_requests/preview?rendered_template=' + encodeURIComponent(rendered_template)
    oReq.send()
    return

  $('#sector_id').on 'change', ->
    $.ajax
      url: baseUrl + '/campaigns/' + $('#campaign_id').val() + '/organizations/' + $(this).val()
      type: 'GET'
      success: (e) ->
        $('#organization_id').children().remove()
        listitems = []
        $.each e, (key, value) ->
          listitems += '<option value="' + value[1] + '">' + value[0] + '</option>'
          return
        $('#organization_id').append listitems
        if listitems.length > 0
          updateTemplateContent e[0][1]
        return
    return
  $('#organization_id').on 'change', ->
    updateTemplateContent $(this).val()
    return
  $('#textTypeRadioStandard').on 'change', ->
    if $(this).is(':checked') and $(this).val() == 'standard'
      $('#textContentStandard').show()
      $('#textContentExpanded').hide()
    return
  $('#textTypeRadioExpanded').on 'change', ->
    if $(this).is(':checked') and $(this).val() == 'expanded'
      $('#textContentStandard').hide()
      $('#textContentExpanded').show()
    return
  return
