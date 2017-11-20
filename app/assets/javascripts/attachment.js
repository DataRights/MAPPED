function showContentEditor() {
  var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
  var ptro = Painterro({
    saveHandler: function (image, done) {
      var formData = new FormData();
      formData.append('image', image.asBlob(), image.suggestedFileName());
      formData.append('authenticity_token',AUTH_TOKEN);
      var xhr = new XMLHttpRequest();
      xhr.open('POST', 'content', true);
      xhr.onload = xhr.onerror = function () {
        done(false);
      };
      xhr.send(formData);
    }
  })
  ptro.show('content');
}
