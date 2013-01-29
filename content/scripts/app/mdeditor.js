function MDEditor(inputElement) {

   this.initialize = function() {
      this.inputElement = inputElement;

      var controlsElement = MDEditor.Utils.appendControls(inputElement);
      this.previewElement  = MDEditor.Utils.appendPreview(inputElement);

      this.activatePreview(this.inputElement);
      this.activateControls(controlsElement);

      this.updating = false;
      this.updatePreview();
   };

   this.activatePreview = function(inputElement) {
      var _self = this;
      $(inputElement).keypress(function(event) {
         if (event.which == 13) {
            _self.updatePreview();
         }
      });
   }

   this.activateControls = function(controlsElement) {
      var _self = this;
      [
         "bold", "italic", "strikethrough", "code",
         "link", "image",
         "title", "list",
         "preview"
      ].forEach(function(actionName) {
         $(controlsElement).find(".mde-" + actionName).click(function(event) {
            _self.action(actionName, event)
         });
      });
      this.previewBtn = $(controlsElement).find(".mde-preview");
   };

   this.updatePreview = function() {
      if (this.updating) {
         return;
      }

      this.updating = true;
      this.previewBtn.addClass('disabled');
      this.previewBtn.find('.mde-spinner').spin(MDEditor.Utils.spinOptions());
      var markdown = $(this.inputElement).val();
      var _self = this;
      $.ajax({
         url: '/markdown',
         type: 'POST',
         data: { content: markdown },
         success: function(data, status, xhr) {
            $(_self.previewElement).html(data);
            _self.updating = false;
            _self.previewBtn.removeClass('disabled');
            _self.previewBtn.find('.mde-spinner').spin(false);
         }
      });
   }

   this.action = function(actionName, event) {
      event.preventDefault();
      if (MDEditor.Actions[ actionName ](this.inputElement)) {
         this.updatePreview();
      }
   };

   this.initialize();
}


/*
  The logic of each of the control buttons
*/
MDEditor.Actions = {

   title: function(inputElement) {
      return MDEditor.Utils.insertAtStart(inputElement, '#', true);
   },

   list: function(inputElement) {
      return MDEditor.Utils.insertAtStart(inputElement, '*', false);
   },

   link: function(inputElement) {
      return MDEditor.Utils.insertLinkOrMedia(inputElement, "[", "](", ")");
   },

   image: function(inputElement) {
      return MDEditor.Utils.insertLinkOrMedia(inputElement, "![", "](", ")");
   },

   bold: function(inputElement) {
      return MDEditor.Utils.wrapSelectionOrInsert(inputElement, '**');
   },

   italic: function(inputElement) {
      return MDEditor.Utils.wrapSelectionOrInsert(inputElement, '_');
   },

   strikethrough: function(inputElement) {
      return MDEditor.Utils.wrapSelectionOrInsert(inputElement, '~~');
   },

   code: function(inputElement) {
      return MDEditor.Utils.wrapSelectionOrInsert(inputElement, '`');
   },

   preview: function(inputElement) {
      return true;
   }
}

MDEditor.Utils = {

   appendControls: function(inputElement) {
      var element = $(MDEditor.Utils.controlsTemplate());
      $(inputElement).before(element);

      return element;
   },

   appendPreview: function(inputElement) {
      var element = $(MDEditor.Utils.previewTemplate());
      $(inputElement).after(element);

      return element;
   },

   wrapSelectionOrInsert: function(inputElement, chars) {
      var $input = $(inputElement);
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

   insertAtStart: function(inputElement, char, duplicate) {
      var $input = $(inputElement);
      var content = $input.val();
      var selection = $input.getSelection();
      var start = selection.start;

      while (start >= 0 && content[start] != "\n") {
         start--;
      }

      $input.setSelection(start + 1, start + 1);
      var text = '';
      if (content[start + 1] != char) {
         text = char + ' ';
      } else if (duplicate) {
         text = char;
      }

      $input.insertAtCaretPos(text);
      $input.setSelection(selection.start + text.length,
            selection.end + text.length);
      return text.length > 0;
   },

   insertLinkOrMedia: function(inputElement, chars1, chars2, chars3) {
      var url = prompt("Url :", "http://");
      if (url == null) {
         return false;
      }

      var selection = $(inputElement).getSelection();
      var text = selection.text;
      if (selection.length == 0) {
         text = prompt("Texte :");
         if (text == null) {
            return false;
         }
      }

      if (selection.length == 0) {
         $(inputElement).insertAtCaretPos(chars1 + text + chars2 + url + chars3);
      } else {
         $(inputElement).replaceSelection(chars1 + text + chars2 + url + chars3);
      }
      return true;
   },

   controlsTemplate: function() {
      var template =
         "<div class=\"mde-buttons mde-control\">" +
         "  <div class=\"btn-group\">" +
         "    <a class=\"btn mde-title\" href=\"#mde-title\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "    <a class=\"btn mde-list\" href=\"#mde-list\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "  </div>" +
         "  <div class=\"btn-group\">" +
         "    <a class=\"btn mde-link\" href=\"#mde-link\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "    <a class=\"btn mde-image\" href=\"#mde-image\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "  </div>" +
         "  <div class=\"btn-group\">" +
         "    <a class=\"btn mde-bold\" href=\"#mde-bold\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "    <a class=\"btn mde-italic\" href=\"#mde-italic\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "    <a class=\"btn mde-strikethrough\" href=\"#mde-strikethrough\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "    <a class=\"btn mde-code\" href=\"#mde-code\">" +
         "      <span class=\"mde-btn-content\"></span>" +
         "    </a>" +
         "  </div>" +
         "  <div class=\"btn-group\">" +
         "    <a class=\"btn mde-preview\" href=\"#mde-preview\">" +
         "        <span class=\"mde-btn-content\"></span>"+
         "        <span class=\"mde-spinner\"></span>" +
         "    </a>" +
         "  </div>" +
         "  <div class=\"clearfix\"></div>" +
         "</div>";

      return template;
   },

   previewTemplate: function() {
      var template = "<div class=\"mde-preview mde-control\"></div>";

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

$(function() {
   jQuery.fn.mdeditor = function() {
      this.each(function(index, inputElement) {
         var mde = new MDEditor(inputElement);
      });
   };

   $(".mdeditor").mdeditor();
});
