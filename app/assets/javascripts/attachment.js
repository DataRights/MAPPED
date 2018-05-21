function showContentEditor(blankImage) {
  var ptro = createBlackOutTool();

  var contentPath = '';
  if (blankImage) {
    ptro.show();
  } else {
    ptro.show('content');
  }
}

function uploadNewFile() {
  document.getElementById('new_file').click()
}

function newFileSelected() {
  var selectedFile = document.getElementById('new_file').files[0]
  if (selectedFile) {
    if (selectedFile.type == 'application/pdf')   {
      $("content_type").val('image/jpeg');
      if ($("#title").val() == '') {
        $("#title").val(selectedFile.name)
      }
      convertPDF(URL.createObjectURL(selectedFile))
    }
    else {
      var reader = new FileReader();
      reader.onload = function() {
        var fileType =
        $("#content_type").val(selectedFile.type);
        if ($("#title").val() == '') {
          $("#title").val(selectedFile.name)
        }
        var fileContent = this.result
        var ptro = createBlackOutTool();
        ptro.show(fileContent, true);
      };
      reader.readAsDataURL(selectedFile);
    }
  }
}

function createBlackOutTool() {
  return Painterro({
    hiddenTools: ['open'],
    saveHandler: function (image, done) {
      var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
      var access_request_step_id = document.getElementsByName('attachment[access_request_step_id]')[0].value

      var formData = new FormData();
      formData.append('authenticity_token',AUTH_TOKEN);
      formData.append('access_request_step_id',access_request_step_id);

      var newFileType = $("#content_type").val();
      var newFileName = $("#title").val();

      formData.append('image', image.asBlob(newFileType), newFileName);
      jQuery.ajax({
          url: 'content',
          data: formData,
          processData: false,
          contentType: false,
          dataType: 'json',
          type: "POST",
          success: function(data) {
            if (data.success == false) {
              alert(data.error.content[0]);
              done(false);
            }
            else {
              done(true);
              window.location.href = '/attachments';
              //window.location.reload();
            }
          },
          failure: function(xhr) {
            console.log(xhr);
          },
      });
    }
  });
}

function showPdfImage(canvases) {
  var mainCanvas = document.getElementById('pdf-canvas');
  var mainCanvasWidth = 0;
  var mainCanvasHeight = 0;
  for (i = 0; i < canvases.length ; i++ ) {
    if (canvases[i].width > mainCanvasWidth) {
      mainCanvasWidth = canvases[i].width;
    }
    mainCanvasHeight = mainCanvasHeight + canvases[i].height;
  }
  mainCanvas.width = mainCanvasWidth;
  mainCanvas.height = mainCanvasHeight;
  var mainCanvasContext = mainCanvas.getContext('2d');
  var lastHeight = 0
  for (i = 0; i < canvases.length; i++) {
    mainCanvasContext.drawImage(canvases[i],0, lastHeight);
    lastHeight = lastHeight + canvases[i].height;
  }
  var ptro = createBlackOutTool();
  ptro.show(mainCanvas.toDataURL(), true);
}

function convertPDF(pdfUrl) {
  var canvases;
  var convertFinished = false; // Race condition resolved.(to avoid opening result multiple time)
  function renderPage(page) {
      var viewport = page.getViewport(1);
      var canvas = document.createElement('canvas');
      var ctx = canvas.getContext('2d');
      var renderContext = {
        canvasContext: ctx,
        viewport: viewport
      };

      canvas.width = viewport.width;
      canvas.height = viewport.height;
      modal = document.createElement('previewModal');
      modal.width = canvas.width + 5
      modal.height = canvas.height + 5

      page.render(renderContext).then(function() {
        canvases[page.pageNumber - 1] = canvas;
        // Check if all canvases are rendered
        var finished = false;
        for (i = 0; i < canvases.length; i++) {
          if (canvases[i] === undefined) {
              break;
          }

          if (!convertFinished) {
            if (i == (canvases.length - 1)) {
              finished = true;
            }
          }

        }

        if (!convertFinished) {
          if (finished) {
            convertFinished = true;
            showPdfImage(canvases);
          }
        }
      });
  }

  function renderPages(pdfDoc) {
    canvases = new Array(pdfDoc.pageNum);
    for(var num = 1; num <= pdfDoc.numPages; num++) {
        pdfDoc.getPage(num).then(renderPage);
    }
  }

  PDFJS.disableWorker = true;
  PDFJS.getDocument(pdfUrl).then(renderPages);
}
