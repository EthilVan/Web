function tabFor(url) {
   var match = (/.+\/(.+?)$/g).exec(url);
   var tabName = (match == null) ? '' : match[1];
   var realTabName = tabName;
   if (realTabName == null || realTabName == '') {
      realTabName = $('.tab-pane-default').attr('id');
   }
   return $('.page-tabs .tab a[data-target="#' + realTabName + '"]');
}

function displayTab(tab) {
   if (tab == null || tab.size() < 1) {
      return;
   }
   document.title = tab.data().title;
   tab.tab('show');
}

$(function() {
   $('ul#nav.page-tabs .tab a').click(function(event) {
      event.preventDefault();
      displayTab($(this));
      var newTab = $(this).attr('data-target').substring(1);
      window.history.pushState({}, null, newTab);
   });

   window.onpopstate = function(event) {
      displayTab(tabFor(window.location.pathname));
   }

   displayTab(tabFor(window.location.pathname));
});
