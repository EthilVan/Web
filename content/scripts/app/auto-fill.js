$(function() {

   var $container = $('[data-autofill]');
   if ($container.size() < 1) {
      return;
   }

   var url = $container.data().autofill || '';
   var param = $container.data().autofillParam || 'page';

   if ($container.data().autofillPage) {
      var currentPage = $container.data().autofillPage;
   } else {
      var match = new RegExp('[?&]' + param + '=([0-9]+)').
         exec(window.location.search);
      var currentPage = (match == null) ? 1 : parseInt(match[1]);
   }

   var paramUrl = url + '?' + param + '='
   var isPageLoading = false;

   function nearBottomOfPage() {
      var $window = $(window);
      var y = $(document).height();
      y -= $window.height();
      y -= 200;
      return $window.scrollTop() > y;
   }

   $(window).scroll(function() {
      if (isPageLoading) {
         return;
      }

      if (nearBottomOfPage()) {
         isPageLoading = true;
         currentPage++;
         $.get(paramUrl + currentPage, function (html, status, xhr) {
            if (xhr.status == 204) {
               return;
            }

            $received = $('<div>' + html + '</div>');
            $container.append($received.find('[data-autofill]').html());
            $(document).trigger('insert');
            isPageLoading = false;
         });
      }
   });
});
