$(function() {

   $('a[data-inline-target]').each(function() {
      var $this = $(this);

      $this.click(function(event) {
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
   });
});
