function showContentEditor(newImage) {
  var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
  var access_request_id = $("[name='attachment[access_request_id]']").val()

  var ptro = Painterro({
    saveHandler: function (image, done) {
      var formData = new FormData();
      formData.append('authenticity_token',AUTH_TOKEN);
      formData.append('image', image.asBlob(), image.suggestedFileName());
      var xhr = new XMLHttpRequest();
      var postPath = 'content';
      if (newImage) {
        postPath = postPath + '/' + access_request_id
      }
      xhr.open('POST',postPath, true);
      xhr.onload = xhr.onerror = function () {
        done(false);
      };
      xhr.send(formData);
    }
  })
  var contentPath = '';
  if (newImage) {
    ptro.show();
  } else {
    ptro.show('content');
  }
}
