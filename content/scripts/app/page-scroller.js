function updateTopBottom() {
   $window = $(window);

   if ($window.scrollTop() > 100) {
      $('#page-scroller-top').fadeIn();
   } else {
      $('#page-scroller-top').fadeOut();
   }

   var height = $(document).height();
   height -= $window.scrollTop();
   height -= $window.height();
   if (height > 100) {
      $('#page-scroller-bottom').fadeIn();
   } else {
      $('#page-scroller-bottom').fadeOut();
   }
}

function scrollTo(y) {
   $('body,html').animate({
      scrollTop: y
   }, 800);
}

$(document).on('click.page-scroller.top',
      '#page-scroller-top', function (event) {
   event.preventDefault();
   scrollTo(0);
});

$(document).on('click.page-scroller.bottom',
      '#page-scroller-bottom', function (event) {
   event.preventDefault();
   scrollTo($(document).height());
});

$(document).ready(function() {
   $(window).scroll(updateTopBottom);
   updateTopBottom(window);
});
