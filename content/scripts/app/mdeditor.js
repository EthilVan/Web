function MDEditor(wrapper) {

   this.initialize = function(wrapper) {
      this.$input      = wrapper.find('.mde-input');
      this.$preview    = wrapper.find('.mde-preview');
      this.$previewBtn = wrapper.find('.mde-dopreview');
      this.$spinner    = wrapper.find('.mde-spinner');

      this.membresMentions = false;
      this.emojisMentions  = false;
      this.updating        = false;
   };

   this.activateMentions = function() {
      var mdeditor = this;
      var $input = mdeditor.$input
      if (!mdeditor.membresMentions) {
         MDEditor.Utils.fetchMembresMentions(function(data) {
            $input.atwho('@', { data: data, limit: 5 });
            mdeditor.membresMentions = true;
         });
      }
      if (!mdeditor.emojisMentions) {
         MDEditor.Utils.fetchEmojisMentions(function(data) {
            $input.atwho(':', {
               data: data, limit: 10,
               tpl: MDEditor.Utils.emojiPreviewTemplate(),
            });
            mdeditor.emojisMentions = true;
         });
      }
   }

   this.updatePreview = function() {
      if (this.updating) {
         return;
      }

      this.updating = true;
      this.$previewBtn.addClass('disabled');
      this.$spinner.spin(MDEditor.Utils.spinOptions());

      var $mdeditor = this;
      $.ajax({
         url: '/markdown',
         type: 'POST',
         data: { content: $mdeditor.$input.val() },
         success: function(data, status, xhr) {
            $mdeditor.$preview.html(data);
            $mdeditor.updating = false;
            $mdeditor.$previewBtn.removeClass('disabled');
            $mdeditor.$spinner.spin(false);
         }
      });
   }

   this.action = function(options) {
      var actionName = options['name'];
      var actionMethod = MDEditor.Actions[actionName];
      if (!actionMethod) {
         return;
      }

      if (options['event'].preventDefault) {
         options['event'].preventDefault();
      }

      if (actionMethod(this.$input, options)) {
         this.updatePreview();
      }
   };

   this.initialize(wrapper);
}


MDEditor.Actions = {

   title: function($input, options) {
      var $control = options['control'];
      var level = parseInt($control.data().mdeTitle);
      if (isNaN(level)) {
         level = 1;
      }

      return MDEditor.Utils.insertAtStart($input, '#', true, level);
   },

   quote: function($input, options) {
      return MDEditor.Utils.insertAtStart($input, '>', false);
   },

   list: function($input, options) {
      return MDEditor.Utils.insertAtStart($input, '*', false);
   },

   link: function($input, options) {
      return MDEditor.Utils.insertLinkOrMedia($input, "[", "](", ")");
   },

   image: function($input, options) {
      return MDEditor.Utils.insertLinkOrMedia($input, "![", "](", ")");
   },

   bold: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '**');
   },

   italic: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '_');
   },

   strikethrough: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '~~');
   },

   code: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '`');
   },

   dopreview: function($input, options) {
      return true;
   }
}

MDEditor.Utils = {

   wrapSelectionOrInsert: function($input, chars) {
      var selection = $input.getSelection();
      if (selection.length == 0) {
         $input.insertAtCaretPos(chars);
         $input.insertAtCaretPos(chars);
         $input.setCaretPos(selection.start + chars.length + 1);
         return false;
      }

      var text = chars + selection.text + chars;
      $input.replaceSelection(text);
      $input.setSelection(selection.start, selection.start + text.length);
      return true;
   },

   insertAtStart: function($input, char, duplicate, countArg) {
      var content = $input.val();
      var selection = $input.getSelection();
      var start = selection.start;
      var count = duplicate ? countArg : 1;

      while (start >= 0 && content[start] != "\n") {
         start--;
      }

      $input.setSelection(start + 1, start + 1);
      var text = '';
      if (content[start + 1] != char) {
         text = this.repeatString(char, count) + ' ';
      } else if (duplicate) {
         text = this.repeatString(char, count);
      }

      $input.insertAtCaretPos(text);
      $input.setSelection(selection.start + text.length,
            selection.end + text.length);
      return text.length > 0;
   },

   repeatString: function(string, count) {
      return new Array(count + 1).join(string);
   },

   insertLinkOrMedia: function($input, chars1, chars2, chars3) {
      var url = prompt("Url :", "http://");
      if (url == null || url == "http://") {
         return false;
      }

      var selection = $input.getSelection();
      var text = selection.text;
      if (selection.length == 0) {
         text = prompt("Texte :");
         if (text == null) {
            return false;
         }
      }

      if (selection.length == 0) {
         $input.insertAtCaretPos(chars1 + text + chars2 + url + chars3);
      } else {
         $input.replaceSelection(chars1 + text + chars2 + url + chars3);
      }
      return true;
   },

   fetchMembresMentions: function(callback) {
      this.fetchMentions('/markdown/membres.json', callback);
   },

   fetchEmojisMentions: function(callback) {
      this.fetchMentions('%%CACHE_BUSTER%%markdown/emojis.json', callback);
   },

   fetchMentions: function(url, callback) {
      var utils = this;
      if (utils[url]) {
         callback(utils[url]);
      } else {
         $.ajax({
            url: url,
            success: function(raw_data, status, xhr) {
               var data = $.map(raw_data, function(name, i) {
                  return { 'name': name };
               });
               utils[url] = data;
               callback(data);
            }
         });
      }
   },

   emojiPreviewTemplate: function() {
      var template =
         "<li data-value='${name}:'>" +
         "  ${name} " +
         "   <img src='/images/emoji/${name}.png' height='20' width='20' />" +
         "</li>"

      return template;
   },

   spinOptions: function() {
      return {
        lines: 11,
        length: 1,
        width: 3,
        radius: 6,
        corners: 1,
        rotate: 0,
        speed: 1,
        trail: 60,
        shadow: true,
        hwaccel: false,
        className: 'spinner',
        zIndex: 2e9,
        top: 'auto',
        left: 'auto'
      };
   }
}

var actionsSelector = Object.keys(MDEditor.Actions).map(function(action) {
   return '[href=#mde-' + action + ']';
}).join(', ');

$(document).on('click.mdeditor.actions',
      actionsSelector, function(event) {
   var $control = $(this);
   var actionName = (/^#mde-(.+)$/).exec($control.attr('href'))[1];
   $control.mdeditor('action', {
      name: actionName,
      event: event,
      control: $control,
   });
});


$(document).on('keypress.mdeditor.preview.shortcut',
      '.mde-input', function(event) {
   if (event.which == 13) {
      $(this).mdeditor('updatePreview');
   }
});

$(document).on('focus.mdeditor.atwho',
      '.mde-input', function(event) {
   $(this).mdeditor('activateMentions');
});

$.fn.mdeditor = function(method, arg) {
   return this.each(function() {
      var $mdeditor = $(this).parents('.mdeditor');
      if (!$mdeditor) {
         return null;
      }

      var data = $mdeditor.data('mdeditor');
      if (!data) {
         data = new MDEditor($mdeditor);
         $mdeditor.data('mdeditor', data);
      }

      if (method) {
         data[method](arg);
      }
  });
}
