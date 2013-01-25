$(document).ready(function(){

   // hide #back-top first
   $("#back-top").hide();

   function updateBackTop() {
      if ($(this).scrollTop() > 100) {
         $('#back-top').fadeIn();
      } else {
         $('#back-top').fadeOut();
      }
   }

   $(function () {
      $(window).scroll(updateBackTop);

      $('#back-top a').click(function () {
         $('body,html').animate({
            scrollTop: 0
         }, 800);
         return false;
      });
   });

   updateBackTop(window);
});
