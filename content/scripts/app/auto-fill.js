$(function() {

   var $container = $('.auto-fill');
   if ($container.size() < 1) {
      return;
   }

   var url = $container.data().autoFillUrl || '';
   var currentPage = 1;
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
         $.get(url + '?page=' + currentPage, function (html, status, xhr) {
            if (xhr.status == 204) {
               return;
            }

            $container.append($(html).html());
            $(document).trigger('insert');
            isPageLoading = false;
         });
      }
   });
});
