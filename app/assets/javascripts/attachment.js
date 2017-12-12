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
      var fileTypeElement = document.getElementById("content_type");
      if  (fileTypeElement) {
        fileTypeElement.value = 'image/jpeg'
      }
      var fileName = selectedFile.name
      var fileNameElement = document.getElementById("title");
      if  (fileName && fileNameElement) {
        fileNameElement.value = fileName
      }
      convertPDF(URL.createObjectURL(selectedFile))
    } else {
      var reader = new FileReader();
      reader.onload = function() {
        var fileType = selectedFile.type
        var fileTypeElement = document.getElementById("content_type");
        if  (fileType && fileTypeElement) {
          fileTypeElement.value = fileType
        }

        var fileName = selectedFile.name
        var fileNameElement = document.getElementById("title");
        if  (fileName && fileNameElement) {
          fileNameElement.value = fileName
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
      var workflow_transition_id = document.getElementsByName('attachment[workflow_transition_id]')[0].value

      var formData = new FormData();
      formData.append('authenticity_token',AUTH_TOKEN);
      formData.append('workflow_transition_id',workflow_transition_id);

      var newFileType = 'image/jpeg'
      var fileTypeElement = document.getElementById("content_type");
      if (fileTypeElement) {
        var fileTypeElementValue = fileTypeElement.value
        if (fileTypeElementValue) {
          newFileType = fileTypeElementValue
        }
      }

      var newFileName = image.suggestedFileName('jpeg')
      var fileNameElement = document.getElementById("title");
      if (fileNameElement) {
        var fileNameElementValue = fileNameElement.value
        if (fileNameElementValue) {
          newFileName = fileNameElementValue
        }
      }

      formData.append('image', image.asBlob(newFileType), newFileName);
      var xhr = new XMLHttpRequest();
      xhr.open('POST','content', true);
      xhr.onload = xhr.onerror = function () {
        done(false);
      };
      xhr.send(formData);
    }
  })
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
