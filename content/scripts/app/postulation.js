$(function() {

   var $postulationForm = $('#postulation-form');
   if ($postulationForm.size() < 1) {
      return;
   }

   $postulationForm.find('.tab-pane').each(function() {
      var tabPane = $(this);

      if (tabPane.find('.errors').size() > 0) {
         var tab = $('.nav-postulation-form a[href="#' + tabPane.attr('id') + '"]');
         tab.tab('show');
         return false;
      }
   });
});
