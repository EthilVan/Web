function display_submenu(event) {
   var name = event.data.name;
   var submenu = $('header #menu .submenu');

   submenu
   if (submenu.hasClass('submenu-' + name)) {
      return;
   }

   submenu.fadeOut(160, function() {
      var template = $('.submenu-templates .submenu-' + name);
      submenu.html(template.html());
      submenu.toggleClass('submenu-server submenu-member');
      submenu.fadeIn(160);
   });
}

$(function() {
   $('.cartes').mousedown(function(event) {
      if (event.which == 2) {
         window.open('http://map.ethilvan.fr', '_blank');
      }
   });

   $('#button1').click({ name: "server" }, display_submenu);
   $('#button2').click({ name: "member" }, display_submenu);
});
