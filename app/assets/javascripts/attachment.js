function showContentEditor(blankImage) {
  var ptro = Painterro({
    hiddenTools: ['open'],
    saveHandler: function (image, done) {
      var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
      var workflow_transition_id = document.getElementsByName('attachment[workflow_transition_id]')[0].value

      var formData = new FormData();
      formData.append('authenticity_token',AUTH_TOKEN);
      formData.append('workflow_transition_id',workflow_transition_id);

      var fileType = 'image/jpeg'
      var fileTypeElement = document.getElementById("content_type");
      if (fileTypeElement) {
        var fileTypeElementValue = fileTypeElement.value
        if (fileTypeElementValue) {
          fileType = fileTypeElementValue
        }
      }

      var fileName = image.suggestedFileName('jpeg')
      var fileNameElement = document.getElementById("title");
      if (fileNameElement) {
        var fileNameElementValue = fileNameElement.value
        if (fileNameElementValue) {
          fileName = fileNameElementValue
        }
      }

      formData.append('image', image.asBlob(fileType), fileName);
      var xhr = new XMLHttpRequest();
      xhr.open('POST','content', true);
      xhr.onload = xhr.onerror = function () {
        done(false);
      };
      xhr.send(formData);
      location.reload(true);
    }
  })

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
      var reader = new FileReader();
      reader.onload = function() {
        var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
        var workflow_transition_id = document.getElementsByName('attachment[workflow_transition_id]')[0].value

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
        var ptro = Painterro({
          hiddenTools: ['open'],
          saveHandler: function (image, done) {
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
            location.reload(true);
          }
        })
        ptro.show(fileContent);
      };
      reader.readAsDataURL(selectedFile);
  }
}
