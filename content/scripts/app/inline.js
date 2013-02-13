function Inline(trigger) {

   this.$trigger = $(trigger);

   this.target = function(type) {
      var targetSelector = this.$trigger.data(type + '-target');
      return this.$trigger.closest(targetSelector);
   }

   this.removeMethod = function() {
      return this.$trigger.data().removeMethod;
   }

   this.before = function() {
      if (this.$trigger.data().inlining) {
         return false;
      }

      this.$trigger.removeClass('inline-error');
      this.$trigger.addClass('disabled');
      this.$trigger.data().inlining = true;
      return true;
   }

   this.ajax = function() {
      if (this.$trigger.is('a')) {
         var options = {
            url: this.$trigger.attr('href'),
         }
      } else if (this.$trigger.is('input')) {
         $form = this.$trigger.parent('form');
         var options = {
            url:  $form.attr('action') || '',
            type: $form.attr('method') || 'GET',
            data: $form.serialize(),
         }
      }

      options.context = this;
      return $.ajax(options);
   }

   this.fail = function() {
      this.$trigger.addClass('inline-error');
   }

   this.after = function() {
      this.$trigger.removeClass('disabled');
      this.$trigger.data('inlining', false);
   }
}

$(document).on('click.ethivan.inline', '[data-inline-target]', function (event) {
   event.preventDefault();

   var inline = new Inline(this);
   if (!inline.before()) {
      return;
   }

   inline.ajax().done(function(data, status, xhr) {
      var $target = inline.target('inline');
      var $element = $(data.trim());
      $element.css('display', 'none');
      $target.fadeOut(800, function() {
         $target.replaceWith($element);
         $(document).trigger('insert');
         $element.fadeIn(800, function() {
            $element.css('display', 'block');
         });
      });
   }).fail(inline.fail).always(inline.after);
});

$(document).on('click.ethilvan.remove', '[data-remove-target]', function (event) {
   event.preventDefault();

   var inline = new Inline(this);
   if (!inline.before()) {
      return;
   }

   bootbox.confirm("Etes vous sûr ?", "Annuler", "Confirmer", function(result) {
      if (!result) {
         inline.after();
         return;
      }

      inline.ajax().done(function(data, status, xhr) {
         var $target = inline.target('remove');
         $target.slideUp(800, function() {
            if (inline.removeMethod() != 'hide') {
               $target.remove();
            }
         });
      }).fail(inline.fail).always(inline.after);
   });
});
