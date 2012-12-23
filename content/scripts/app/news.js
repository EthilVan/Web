$(function() {

   $newses = $('.newses');
   if ($newses.children().size() < 2) {
      return;
   }

   var newsPage = 1;
   var newsPageLoading = false;

   function nearBottomOfPage() {
      var $window = $(window);
      var y = $(document).height();
      y -= $window.height();
      y -= 200;
      return $window.scrollTop() > y;
   }

   $(window).scroll(function() {
      if (newsPageLoading) {
         return;
      }

      if (nearBottomOfPage()) {
         newsPageLoading = true;
         newsPage++;
         $.get('/news?page=' + newsPage, function (html) {
            $newses.append($(html).html());
            newsPageLoading = false;
         });
      }
   });
});
