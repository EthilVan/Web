$(function() {

   $('[data-text-counter]').each(function() {
      var $this = $(this);
      var data = $this.data();

      var min = data.textCounterMin || data.minlength || null;
      var max = data.textCounterMin || data.maxlength || null;

      $this.miniCount({
         min: min,
         max: max,
         className: 'text-counter',
         validClassName: 'text-counter-valid',
         invalidClass: 'text-counter-invalid',
      });
   });
});
