$(document).on('click.ethilvan.postulation-vote',
      '.postulation-vote-button', function(event) {
   event.preventDefault();
   $('#form-postulation-vote').slideDown(800);
   $('#postulation_vote_agreement').attr('checked',
      $(this).attr('href') == '#agreement');
});
