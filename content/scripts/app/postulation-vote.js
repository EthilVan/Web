$(document).on('click.ethilvan.postulation-vote',
      '.postulation-vote-button', function(event) {
   event.preventDefault();

   if ($(this).is('.disabled')) {
      return;
   }

   $('#form-postulation-vote').slideDown(800);
   $('#postulation_vote_agreement').attr('checked',
         $(this).attr('href') == '#agreement');
   $('.postulation-vote-button').removeClass('disabled');
   $(this).addClass('disabled');
});
