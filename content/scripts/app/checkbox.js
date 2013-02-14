var Checkbox = function($input) {
   this.initialize($input);
};

Checkbox.prototype = {

   constructor: Checkbox,

   initialize: function($input) {
      this.$input = $input;
      this.checkboxType = this.$input.data().checkboxInput || '';
      this.$custom = $input.next('[data-checkbox-custom]');
   },

   update: function(target) {
      if (this.checkboxType == 'switch') {
         this.updateSwitch(target);
      } else {
         this.updateCheckbox();
      }
   },

   updateCheckbox: function() {
      var checked = !this.$input.is(':checked');
      this.$input.attr('checked', checked);
      this.$input.trigger('change');
      var toggle = checked ? 'addClass' : 'removeClass';
      this.$custom[toggle]('checked');
   },

   updateSwitch: function(target) {
      if (target.is('.active')) {
         return;
      }

      var checked = this.$input.val() != '1';
      this.$input.val(checked ? '1' : '0');
      this.$input.trigger('change');
      this.$custom.find('[data-checkbox-switch]').each(function() {
         var $switch = $(this);
         var active = ($switch.data().checkboxSwitch == 'checked') == checked;
         var toggle = active ? 'addClass' : 'removeClass';
         $switch[toggle]('active');
      });
   },
}

$.fn.customCheckbox = function(method, arg) {
   return this.each(function() {
      var $input = $(this);
      var data = $input.data('checkbox-object');

      if (!data) {
         data = new Checkbox($input);
         $input.data('checkbox-object', data);
      }

      if (method) {
         data[method](arg);
      }
   });
}

$(document).on('click.checkbox.custom',
      '[data-checkbox-custom]', function(event) {
   event.preventDefault();

   $(this).prev('[data-checkbox-input]')
         .customCheckbox('update', $(event.target));
});
