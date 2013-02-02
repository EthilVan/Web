$(function() {

   var $form = $('#postulation-form');
   if ($form.size() < 1) {
      return;
   }

   var disableField = function(fieldContainer) {
      var field = fieldContainer.find('textarea, select');
      field.parsley('destroy');
      fieldContainer.slideUp(400);
   }

   var enableField = function(fieldContainer) {
      var field = fieldContainer.find('textarea, select');
      field.parsley();
      fieldContainer.slideDown(400);
   }

   var oldServer = $form.find('.field-postulation_old_server');
   var oldServerReason = $form.find('.field-postulation_old_server_reason');
   var onMultiMinecraftChange = function(multiMinecraft) {
      if (multiMinecraft.is(':checked')) {
         enableField(oldServer);
         enableField(oldServerReason);
      } else {
         disableField(oldServer);
         disableField(oldServerReason);
      }
   }

   var mumbleOther = $form.find('.field-postulation_mumble_other');
   var onMumbleChange = function(mumbleSelect) {
      if (mumbleSelect.val() == 'Autre') {
         enableField(mumbleOther);
      } else {
         disableField(mumbleOther);
      }
   }

   var mumble = $form.find('.field-postulation_mumble');
   var onMicrophoneChange = function(microphone) {
      if (microphone.is(':checked')) {
         enableField(mumble);
         onMumbleChange($form.find('.field-postulation_mumble select'));
      } else {
         disableField(mumble);
         disableField(mumbleOther);
      }
   }

   $form.find('.field-postulation_multi_minecraft input[type=checkbox]').change(function() {
      onMultiMinecraftChange($(this));
   });
   $form.find('.field-postulation_microphone input[type=checkbox]').change(function() {
      onMicrophoneChange($(this));
   });
   $form.find('.field-postulation_mumble select').change(function() {
      onMumbleChange($(this));
   });

   onMultiMinecraftChange($form.find('.multi_minecraft input[type=checkbox]'));
   onMicrophoneChange($form.find(' .microphone input[type=checkbox]'));
   onMumbleChange($form.find('.mumble select'));

   var screensNextId = $form.find('fieldset.field-screen').size();
   var screensCount = screensNextId;

   var replaceScreenTitle = function(screen) {
      var title = $(screen).find('h4');
      title.html(title.html().replace(/Screenshot [0-9]+/,
            'Screenshot ' + screensCount));
   };

   var onScreenRemove = function(event) {
      event.preventDefault();
      $(this).parent().remove();

      screensCount = 0;
      $form.find('fieldset.field-screen').each(function() {
         screensCount += 1;
         replaceScreenTitle($(this));
      });
   };

   $('.add-screen').click(function(event) {
      event.preventDefault();

      screensNextId++;
      screensCount++;
      var template = $form.find('.field-screen-template').html();
      template = template.replace(/%%template%%/g, screensNextId);
      var newScreen = $('<fieldset class="field-screen">' +
            template +
            '</fieldset>');
      replaceScreenTitle(newScreen);
      newScreen.find('.remove-screen').click(onScreenRemove);
      $(this).before(newScreen);
   });

   $('.remove-screen').click(onScreenRemove);

   // Activate first tab pane which contains errors
   var activateFirstTabWithErrors = function() {
      $form.find('.tab-pane').each(function() {
         var tabPane = $(this);

         if (tabPane.find('.errors, .parsley-error-list').size() > 0) {
            var tab = $('.nav-postulation-form a[href="#' + tabPane.attr('id') + '"]');
            tab.tab('show');
            return false;
         }
      });
   };

   window.ParsleyConfig = $.extend(true, {}, window.ParsleyConfig, {
      listeners: {
         onFormSubmit: function(isFormValid, event, ParsleyForm) {
            activateFirstTabWithErrors();
         }
      }
   });

   activateFirstTabWithErrors();
});
