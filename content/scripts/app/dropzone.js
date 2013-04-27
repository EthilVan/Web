Dropzone.autoDiscover = false;

$(document).ready(function() {

   $('.dropzone').dropzone({
      url: '/membre/upload',
      init: function() {
         this.on('success', function(file, response) {
            $(file.previewTemplate).append(
               '<a href="' + response + '">' +
                  'Lien' +
               '</a>'
            );
         });
      }
   });
});
