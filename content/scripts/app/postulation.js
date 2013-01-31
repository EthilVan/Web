$(function() {

   var $form = $('#postulation-form');
   if ($form.size() < 1) {
      return;
   }

   var oldServer = $form.find('.field-postulation_old_server');
   var oldServerReason = $form.find('.field-postulation_old_server_reason');
   var onMultiMinecraftChange = function(multiMinecraft) {
      if (multiMinecraft.is(':checked')) {
         oldServer.slideDown(400);
         oldServerReason.slideDown(400);
      } else {
         oldServer.slideUp(400);
         oldServerReason.slideUp(400);
      }
   }

   var mumbleOther = $form.find('.field-postulation_mumble_other');
   var onMumbleChange = function(mumbleSelect) {
      if (mumbleSelect.val() == 'Autre') {
         mumbleOther.slideDown(400);
      } else {
         mumbleOther.slideUp(400);
      }
   }

   var mumble = $form.find('.field-postulation_mumble');
   var onMicrophoneChange = function(microphone) {
      if (microphone.is(':checked')) {
         mumble.slideDown(400);
         onMumbleChange($form.find('.field-postulation_mumble select'));
      } else {
         mumble.slideUp(400);
         mumbleOther.slideUp(400);
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
      template = template.replace(/postulation_screen_url_[0-9]+/g,
            'postulation_screen_url_' + screensNextId);
      template = template.replace(/postulation_screen_description_[0-9]+/g,
            'postulation_screen_description_' + screensNextId);
      var newScreen = $('<fieldset class="field-screen">' +
            template +
            '</fieldset>');
      replaceScreenTitle(newScreen);
      newScreen.find('.remove-screen').click(onScreenRemove);
      $(this).before(newScreen);
   });

   $('.remove-screen').click(onScreenRemove);

   // Activate first tab pane which contains errors
   $form.find('.tab-pane').each(function() {
      var tabPane = $(this);

      if (tabPane.find('.errors').size() > 0) {
         var tab = $('.nav-postulation-form a[href="#' + tabPane.attr('id') + '"]');
         tab.tab('show');
         return false;
      }
   });
});
