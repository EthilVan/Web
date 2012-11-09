/// <reference path="../definitions/jquery.d.ts" />
/// <reference path="../definitions/marked.d.ts" />

marked.setOptions({
  gfm: true,
  pedantic: false,
  sanitize: true,
  highlight: null
});

$(function() {
   var elements = $('.markdown-raw').map(function() { return $(this); }).get();
   var i = 0;
   var fun = function() {
      var elem = elements[i];
      elem.html(marked(elem.html()));
      elem.removeClass('markdown-raw');
      i++;
      setTimeout(fun, 1);
   };
   fun();
});

// var editor = new EpicEditor().load();
