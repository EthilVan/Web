$(document).on('click', '[data-logged-in="member"] .buttons',
      function(event) {

   event.preventDefault();
   var $visible = $('header #menu .submenu.submenu-visible');
   var $hidden  = $('header #menu .submenu.submenu-hidden');

   var name = ($(this).attr('id') == 'button1') ? 'server' : 'member';

   if ($visible.hasClass('submenu-' + name)) {
      return;
   }

   $visible.fadeOut(160, function() {
      $visible.toggleClass('submenu-visible submenu-hidden');
      $hidden.fadeIn(160, function() {
         $hidden.toggleClass('submenu-visible submenu-hidden');
      });
   });
});
