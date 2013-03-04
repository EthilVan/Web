var TextCounter = function($element) {
   this.init($element);
};

TextCounter.prototype = {

   init: function($element) {
      this.$element = $element;
      this.$counterWrapper = $element.parent().find('[data-text-counter-wrapper]');
      this.$counter = this.$counterWrapper.find('[data-text-counter-target]');

      this.state = null;
      var data = this.$element.data();
      this.min = data.textCounterMin || data.minlength || null;
      this.max = data.textCounterMin || data.maxlength || null;
   },

   setState: function(value, klass) {
      if (this.state == value) {
         return;
      }

      this.state = value;
      this.setClass(klass);
   },

   setClass: function(klass) {
      this.$element.removeClass(
            'text-counter-idle text-counter-invalid text-counter-valid');
      this.$counterWrapper.removeClass(
            'text-counter-idle text-counter-invalid text-counter-valid');
      this.$element.addClass(klass);
      this.$counterWrapper.addClass(klass);
   },

   setIdle: function() {
      this.setState(null, 'text-counter-idle');
      this.setCount('-');
   },

   setInvalid: function() {
      this.setState(false, 'text-counter-invalid');
   },

   setValid: function() {
      this.setState(true, 'text-counter-valid');
   },

   setCount: function(count) {
      this.$counter.text(count);
   },

   update: function() {
      var count  = this.$element.val().length;

      if ((this.min && count < this.min) || (this.max && count > this.max)) {
         this.setInvalid();
      } else {
         this.setValid();
      }

      this.setCount(count);
   },
}

$.fn.textCounter = function(method) {
   var $element = $(this);

   var object = $element.data('text-counter-object');
   if (!object) {
      object = new TextCounter($element);
      $element.data('text-counter-object', object);
   }

   if (method) {
      object[method]();
   }
};

$(document).on('focus.text-counter keyup.text-counter change.text-counter',
      '[data-text-counter]', function() {
   $(this).textCounter('update');
});
