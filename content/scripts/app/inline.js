$(document).on('click.ethivan.inline', 'a[data-inline-target]', function (event) {
   var $this = $(this);
   event.preventDefault();

   $.ajax({
      url: $this.attr('href'),
      success: function(data, status, xhr) {
         var $target = $this.closest($this.data().inlineTarget);
         var $element = $(data);
         $element.css('display', 'none');
         $target.fadeOut(800, function() {
            $target.replaceWith($element);
            $element.fadeIn(800);
         });
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
            var $target = $this.closest($this.data().removeTarget);
            $target.slideUp(800, function() {
               $target.remove();
            });
         }
      });
   });
});
