$(document).on('click.ethivan.inline', 'a[data-inline-target]', function (event) {
   var $this = $(this);
   event.preventDefault();

   $.ajax({
      url: $this.attr('href'),
      success: function(data, status, xhr) {
         var target = $this.closest($this.data().inlineTarget);
         target.html(data);
         target.find(".mdeditor").mdeditor();
      }
   });
});

$(document).on('click.ethilvan.remove', 'a[data-remove-target]', function (event) {
   var $this = $(this);
   event.preventDefault();

   bootbox.confirm("Etes vous sûr ?", "Annuler", "Confirmer", function(result) {
      if (!result) {
         return;
      }

      $.ajax({
         url: $this.attr('href'),
         success: function(data, status, xhr) {
            var target = $this.closest($this.data().removeTarget);
            target.remove();
         }
      });
   });
});
