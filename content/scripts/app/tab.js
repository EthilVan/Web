/// <reference path="../definitions/bootstrap.d.ts" />

function tabNameFor(url) {
   var match = (/.+\/(.+?)$/g).exec(url);
   if (match == null) {
      return '';
   } else {
      return match[1];
   }
}

function displayTab(tabName) {
   var realTabName = tabName;
   if (realTabName == null || realTabName == '') {
      realTabName = $('.tab-pane-default').attr('id');
   }
   var tab = $('ul#nav .tab a[data-target="#' + realTabName + '"]');
   tab.tab('show');
}

$(function() {
   $('ul#nav .tab a').click(function(event) {
      event.preventDefault();
      $(this).tab('show');
      var newTab = $(this).attr('data-target').substring(1);
      window.history.pushState({}, null, newTab);
   });

   window.onpopstate = function(event) {
      displayTab(tabNameFor(window.location.pathname));
   }

   displayTab(tabNameFor(window.location.pathname));
});
