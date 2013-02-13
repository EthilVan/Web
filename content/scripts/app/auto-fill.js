function AutoFill($container) {

   this.initialize = function($container) {
      this.$container = $container;
      this.isPageLoading = false;
      url = $container.data().autofill || '';
      param = $container.data().autofillParam || 'page';
      if ($container.data().autofillPage) {
         this.currentPage = $container.data().autofillPage;
      } else {
         var match = new RegExp('[?&]' + param + '=([0-9]+)').
            exec(window.location.search);
         this.currentPage = (match == null) ? 1 : parseInt(match[1]);
      }
      this.paramUrl = url + '?' + param + '=';
   }

   this.trigger = function() {
      if (this.isPageLoading) {
         return;
      }

      if (this.$container.is('.tab-pane') && !this.$container.is('.active')) {
         return;
      }

      this.isPageLoading = true;
      this.currentPage++;
      $.ajax({
         context: this,
         url: this.paramUrl + this.currentPage,
      }).done(function (html, status, xhr) {
         if (xhr.status == 204) {
            return;
         }

         var $received = $('<div>' + html + '</div>');
         var $newContents = $received.find('[data-autofill-target]');
         if ($newContents.size() < 1) {
            $newContents = $received.find('[data-autofill]');
         }

         var $target = $($newContents.data().autofillTarget);
         if ($target.size() < 1) {
            $target = $container;
         }

         $target.append($newContents.html());

         $(document).trigger('insert');
         this.isPageLoading = false;
      });
   }

   this.initialize($container);
}

var nearBottomOfPage = function() {
   var $window = $(window);
   var y = $(document).height();
   y -= $window.height();
   y -= 200;
   return $window.scrollTop() > y;
}

$(window).on('scroll.autofill', function(event) {
   if (nearBottomOfPage()) {
      var $containers = $('[data-autofill]');
      $containers.autofill('trigger');
   }
});

$.fn.autofill = function(method) {
   return this.each(function() {
      var $container = $(this);
      if (!$container) {
         return null;
      }

      var data = $container.data('autofill-object');
      if (!data) {
         data = new AutoFill($container);
         $container.data('autofill-object', data);
      }

      if (method) {
         data[method]();
      }
  });
}
