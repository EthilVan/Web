function inlineAjax($element, success) {
   if ($element.is('a')) {
      var ajaxArgs = {
         url: $element.attr('href'),
      }
   } else if ($element.is('input')) {
      $form = $element.parent('form');
      var ajaxArgs = {
         url: $form.attr('action'),
         type: $form.attr('method') || 'GET',
         data: $form.serialize(),
      }
   } else {
      return;
   }

   ajaxArgs.success = success;
   $.ajax(ajaxArgs);
}

$(document).on('click.ethivan.inline', '[data-inline-target]', function (event) {
   var $this = $(this);
   event.preventDefault();

   inlineAjax($this, function(data, status, xhr) {
      var $target = $this.closest($this.data().inlineTarget);
      var $element = $(data.trim());
      $element.css('display', 'none');
      $target.fadeOut(800, function() {
         $target.replaceWith($element);
         $(document).trigger('insert');
         $element.fadeIn(800, function() {
            $element.css('display', 'block');
         });
      });
   });
});

$(document).on('click.ethilvan.remove', '[data-remove-target]', function (event) {
   var $this = $(this);
   event.preventDefault();

   bootbox.confirm("Etes vous sûr ?", "Annuler", "Confirmer", function(result) {
      if (!result) {
         return;
      }

      inlineAjax($this, function(data, status, xhr) {
         var $target = $this.closest($this.data().removeTarget);
         $target.slideUp(800, function() {
            if ($this.data().removeMethod != 'hide') {
               $target.remove();
            }
         });
      });
   });
});
