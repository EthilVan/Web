$(document).on('focus.text-counter', 'textarea', function() {

   $(this).autosize({ append: "\n" })
});
