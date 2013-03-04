var Formidable = {

   Field: {

      create: function($field) {
         var object;
         if ($field.is('select')) {
            object = new Formidable.Field.Select($field);
         } else if ($field.is('input[type="checkbox"]')) {
            object = new Formidable.Field.Checkbox($field);
         } else if ($field.is('input[type="text"]')) {
            object = new Formidable.Field.TextInput($field);
         } else {
            return undefined;
         }
         object.$field = $field;
         return object;
      },

      TextInput: function($field) {
         this.$field = $field;

         this.value = function(value) {
            return this.$field.val();
         };

         this.update = function(value) {
            this.$field.val(value);
            this.$field.trigger('change');
         };
      },

      Checkbox: function($field) {
         this.$field = $field;

         this.value = function() {
            return this.$field.is(':checked');
         };

         this.update = function(value) {
            this.$field.attr('checked', value);
            this.$field.trigger('change');
         };
      },

      Select: function($field) {
         this.$field = $field;

         this.value = function() {
            return this.$field.val();
         };

         this.update = function(value) {
            this.$field.find('option').each(function() {
               var $option = $(this);
               $option.attr('selected', $option.attr('value') == value);
            });
            this.$field.trigger('change');
         };
      },
   },

   Custom: {

      create: function(type, $custom) {
         var object;
         if (type == 'checkbox') {
            object = new Formidable.Custom.Checkbox();
         } else if (type == 'picker') {
            object = new Formidable.Custom.Picker();
         } else if (type == 'toggle') {
            object = new Formidable.Custom.Toggle();
         } else if (type == 'switch') {
            object = new Formidable.Custom.Switch();
         } else {
            return undefined;
         }
         object.$custom = $custom;
         var $raw_field = $custom.prev('[data-formidable="field"]');
         object.$field  = Formidable.Field.create($raw_field);
         if (!object.$field) {
            return undefined;
         }

         object.update(object.$field.value());
         return object;
      },

      Checkbox: function() {
         this.update = function(value) {
            this.$custom[value ? 'addClass' : 'removeClass']('checked');
         };

         this.click = function(event) {
            event.preventDefault();
            var value = !this.$field.value();
            this.$field.update(value);
            this.update(value);
         };
      },

      Picker: function() {
         this.update = function(value) {
            var $target = this.$custom.find('[data-formidable-item="' + value + '"]');
            this.$custom.find('[data-formidable-picker]').html($target.html());
         };

         this.click = function(event) {
            var $target = $(event.target);

            var value = $target.data().formidableItem;
            if (value == undefined) {
               return;
            }

            event.preventDefault();
            this.$field.update(value);
            this.update(value);
         };
      },

      Toggle: function() {
         this.update = function(value) {
            this.$custom[value ? 'addClass' : 'removeClass']('active');
         };

         this.click = function(event) {
            event.preventDefault();
            var value = !this.$field.value();
            this.$field.update(value);
            this.update(value);
         };
      },

      Switch: function() {
         this.update = function(value) {
            this.$custom.find('[data-formidable-item]').removeClass('active');
            this.$custom.find('[data-formidable-item="' + value + '"]')
                  .addClass('active');
         };

         this.click = function(event) {
            var $target = $(event.target);

            var value = $target.data().formidableItem;
            if (value == undefined) {
               return;
            }

            event.preventDefault();
            this.$field.update(value);
            this.update(value);
         };
      },
   },
};

$.fn.formidable = function(method, arg) {
   return this.each(function() {
      var $custom = $(this);
      var type = $custom.data().formidable;
      var object = $custom.data('formidable-object');
      if (!object) {
         object = new Formidable.Custom.create(type, $custom);
         if (!object) {
            return;
         }
         $custom.data('formidable-object', object);
      }

      if (method) {
         object[method](arg);
      }
   });
}

$(document).on('click.formidable',
      '[data-formidable][data-formidable!="field"]', function(event) {
   $(this).formidable('click', event);
});

$(document).on('ready', function() {
   $('[data-formidable][data-formidable!="field"]').formidable();
});
