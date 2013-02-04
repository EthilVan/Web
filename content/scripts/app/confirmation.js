bootbox.setLocale('fr');

$(document).on('click.ethilvan.confirmation', 'a.need-confirmation', function (event, data) {
   var $this = $(this);
   if (data == 'confirmed') {
      window.location = $this.attr('href');
      return;
   }

   event.preventDefault();
   bootbox.confirm("Etes vous sûr ?", "Annuler", "Confirmer", function(result) {
      if (result) {
         $this.trigger('click', ['confirmed']);
      }
   });
});
