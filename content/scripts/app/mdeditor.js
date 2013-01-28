function MDEditor(inputElement) {

   this.initialize = function() {
      this.inputElement = inputElement;

      this.controlsElement = MDEditor.Utils.appendControls(inputElement);
      this.previewElement  = MDEditor.Utils.appendPreview(inputElement);

      this.activatePreview(this.inputElement);
      this.activateControls(this.controlsElement);
      this.activateInput(this.inputElement, this.controlsElement, this.previewElement);

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
         "bold", "italic",
         "link", "image",
         "title", "list",
         "preview"
      ].forEach(function(actionName) {
         $(controlsElement).find(".mde-" + actionName).click(function(event) {
            _self.action(actionName, event)
         });
      });
   };

   this.activateInput = function(inputElement, controlsElement, previewElement) {
      $(inputElement).focus(function() {
         $(controlsElement).addClass("focus");
         $(previewElement).addClass("focus");
         $(controlsElement).removeClass("blur");
         $(previewElement).removeClass("blur");
      });

      $(inputElement).blur(function() {
         $(controlsElement).removeClass("focus");
         $(previewElement).removeClass("focus");
         $(controlsElement).addClass("blur");
         $(previewElement).addClass("blur");
      });
   };

   this.updatePreview = function() {
      if (this.updating) {
         return;
      }

      this.updating = true;
      var markdown = $(this.inputElement).val();
      var _self = this;
      $.ajax({
         url: '/markdown',
         type: 'POST',
         data: { content: markdown },
         success: function(data, status, xhr) {
            $(_self.previewElement).html(data);
            _self.updating = false;
         }
      });
   }

   this.action = function(actionName, event) {
      event.preventDefault();
      MDEditor.Actions[ actionName ](this.inputElement);
      this.updatePreview();
   };

   this.initialize();
}


/*
  The logic of each of the control buttons
*/
MDEditor.Actions = {
   bold: function(inputElement) {
      var selection = $(inputElement).getSelection();
      $(inputElement).replaceSelection("**" + selection.text + "**");
   },

   italic: function(inputElement) {
      var selection = $(inputElement).getSelection();
      $(inputElement).replaceSelection("_" + selection.text + "_");
   },

   link: function(inputElement) {
      var link = prompt("Link to URL", "http://");
      var selection = $(inputElement).getSelection();
      $(inputElement).replaceSelection("[" + selection.text + "](" + link + ")");
   },

   image: function(inputElement) {
      var url = prompt("Image url", "http://");
      var selection = $(inputElement).getSelection();
      $(inputElement).replaceSelection("![" + selection.text + "](" + url + ")");
   },

   title: function(inputElement) {
      MDEditor.Utils.selectWholeLines(inputElement);
      var selection = $(inputElement).getSelection();
      var hash = (selection.text.charAt(0) == "#") ? "#" : "# ";
      $(inputElement).replaceSelection(hash + selection.text);
   },

   list: function(inputElement) {
      MDEditor.Utils.selectWholeLines(inputElement);
      var selection = $(inputElement).getSelection();
      var text = selection.text;
      var result = "";
      var lines = text.split("\n");
      for(var i = 0; i < lines.length; i++) {
         var line = $.trim(lines[i]);
         if(line.length > 0) result += "* " + line + "\n";
      }

      $(inputElement).replaceSelection(result);
   },

   preview: function(inputElement) {
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

   selectWholeLines: function(inputElement) {
      var content = $(inputElement).val();
      var selection = $(inputElement).getSelection();
      var iniPosition = (selection.start > 0) ? (selection.start - 1) : 0;
      var endPosition = selection.end;

      while(content[iniPosition] != "\n" && iniPosition >= 0) {
         iniPosition--;
      }

      while(content[endPosition] != "\n" && endPosition <= content.length) {
         endPosition++;
      }

      $(inputElement).setSelection(iniPosition + 1, endPosition);
   },

   controlsTemplate: function() {
      var template =
         "<div class=\"mde-buttons mde-control\">" +
         "  <div class=\"btn-group\">" +
         "    <a class=\"btn mde-bold\" href=\"#mde-bold\"><span></span></a>" +
         "    <a class=\"btn mde-italic\" href=\"#mde-italic\"><span></span></a>" +
         "    <a class=\"btn mde-link\" href=\"#mde-link\"><span></span></a>" +
         "    <a class=\"btn mde-image\" href=\"#mde-image\"><span></span></a>" +
         "    <a class=\"btn mde-list\" href=\"#mde-list\"><span></span></a>" +
         "    <a class=\"btn mde-title\" href=\"#mde-title\"><span></span></a>" +
         "  </div>" +
         "  <div class=\"btn-group\">" +
         "    <a class=\"btn mde-preview\" href=\"#mde-preview\"><span></span></a>" +
         "  </div>" +
         "  <div class=\"clearfix\"></div>" +
         "</div>";

      return template;
   },

   previewTemplate: function() {
      var template = "<div class=\"mde-preview mde-control\"></div>";

      return template;
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
