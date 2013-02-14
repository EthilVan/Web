var Checkbox = function($input) {
   this.initialize($input);
};

Checkbox.prototype = {

   constructor: Checkbox,

   initialize: function($input) {
      this.$input = $input;
      this.$custom = $input.next('[data-checkbox-custom]');
   },

   update: function() {
      var checked = this.$input.is(':checked');
      this.$input.attr('checked', !checked);
      var toggle = checked ? 'removeClass' : 'addClass';
      this.$custom[toggle]('checked');
   },
}

$.fn.customCheckbox = function(method) {
   return this.each(function() {
      var $input = $(this);
      var data = $input.data('checkbox-object');

      if (!data) {
         data = new Checkbox($input);
         $input.data('checkbox-object', data);
      }

      if (method) {
         data[method]();
      }
   });
}

$(document).on('click.checkbox.custom',
      '[data-checkbox-custom]', function(event) {
      event
   $(this).prev('[data-checkbox-input]')
         .customCheckbox('update');
});
