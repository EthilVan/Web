/// <reference path="../definitions/jquery.d.ts" />

var opts = {
   parser: function(string) {
      var res = 'Test';
      $.ajax({
         url: '/markdown',
         type: 'POST',
         async: false,
         data: { content: string },
         success: function(data, status, xhr) {
            res = data;
         }
      });
      return res;
   }
};

$(function() {
   var epiceditor = $('#epiceditor');
   if (epiceditor.length > 0) {
      var editor = new EpicEditor(opts).load();
   }
});
