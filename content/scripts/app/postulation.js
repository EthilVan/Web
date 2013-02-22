$(function() {

   var $form = $('#postulation-form');
   if ($form.size() < 1) {
      return;
   }

   var disableField = function(fieldContainer) {
      var field = fieldContainer.find('textarea, select');
      field.parsley('destroy');
      field.attr('disabled', true);
      fieldContainer.slideUp(400);
   }

   var enableField = function(fieldContainer) {
      var field = fieldContainer.find('textarea, select');
      field.parsley();
      field.attr('disabled', false);
      fieldContainer.slideDown(400);
   }

   var oldServer = $form.find('.field-postulation_old_server');
   var oldServerReason = $form.find('.field-postulation_old_server_reason');
   var onMultiMinecraftChange = function(multiMinecraft) {
      if (multiMinecraft.val() == 'true') {
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
      if (microphone.val() == 'true') {
         enableField(mumble);
         onMumbleChange($form.find('[name="postulation[mumble]"]'));
      } else {
         disableField(mumble);
         disableField(mumbleOther);
      }
   }

   $form.find('[name="postulation[multi_minecraft]"]').change(function() {
      onMultiMinecraftChange($(this));
   });
   $form.find('[name="postulation[microphone]"]').change(function() {
      onMicrophoneChange($(this));
   });
   $form.find('[name="postulation[mumble]"]').change(function() {
      onMumbleChange($(this));
   });

   onMultiMinecraftChange($form.find('[name="postulation[multi_minecraft]"]'));
   onMicrophoneChange($form.find('[name="postulation[microphone]"]'));
   onMumbleChange($form.find('[name="postulation[mumble]"]'));

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

$(document).on('click', 'a[data-toggle="next-pill"]', function(event) {
   event.preventDefault();

   var $nav = $($(this).data().navTarget);
   var $active = $nav.find('.active');
   if ($active.size() < 1) {
      var $nextPill = $nav.find('li').first();
   } else {

      var paneSelector = $active.find('a').attr('href');
      var $pane = $(paneSelector)
      $pane.find('input, textarea, select').each(function() {
         var $field = $(this);
         if ($field.is(':disabled')) {
            return;
         }

         $field.parsley('validate');
      });

      if ($pane.find('.errors, .parsley-error-list').size() > 0) {
         return;
      }

      var $nextPill = $active.next();
   }

   if ($nextPill.size() < 1) {
      return;
   }

   $nextPill.find('a[data-toggle]').trigger('click');
   $('body,html').animate({
      scrollTop: $nav.offset().top - 10
   }, 800);
});
