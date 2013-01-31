$(function() {

   var $form = $('#postulation-form');
   if ($form.size() < 1) {
      return;
   }

   var old_server = $form.find('.field-postulation_old_server');
   var old_server_reason = $form.find('.field-postulation_old_server_reason');
   var on_multi_minecraft_change = function(multi_minecraft) {
      if (multi_minecraft.is(':checked')) {
         old_server.slideDown(400);
         old_server_reason.slideDown(400);
      } else {
         old_server.slideUp(400);
         old_server_reason.slideUp(400);
      }
   }

   var mumble_other = $form.find('.field-postulation_mumble_other');
   var on_mumble_change = function(mumble_select) {
      if (mumble_select.val() == 'Autre') {
         mumble_other.slideDown(400);
      } else {
         mumble_other.slideUp(400);
      }
   }

   var mumble = $form.find('.field-postulation_mumble');
   var on_microphone_change = function(microphone) {
      if (microphone.is(':checked')) {
         mumble.slideDown(400);
         on_mumble_change($form.find('.field-postulation_mumble select'));
      } else {
         mumble.slideUp(400);
         mumble_other.slideUp(400);
      }
   }

   $form.find('.field-postulation_multi_minecraft input[type=checkbox]').change(function() {
      on_multi_minecraft_change($(this));
   });
   $form.find('.field-postulation_microphone input[type=checkbox]').change(function() {
      on_microphone_change($(this));
   });
   $form.find('.field-postulation_mumble select').change(function() {
      on_mumble_change($(this));
   });

   on_multi_minecraft_change($form.find('.multi_minecraft input[type=checkbox]'));
   on_microphone_change($form.find(' .microphone input[type=checkbox]'));
   on_mumble_change($form.find('.mumble select'));

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
