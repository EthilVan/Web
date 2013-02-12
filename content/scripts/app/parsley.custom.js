window.ParsleyConfig = window.ParsleyConfig || {};

(function ($) {
   window.ParsleyConfig = $.extend(true, {}, window.ParsleyConfig, {

      validators: {

         nameformat: function(val) {
            var regExp = /^[A-Za-z][\w\-_]{1,}$/;
            return '' !== val ? regExp.test(val) : false;
         },

         datefr: function(val) {
            var regExp = /^(\d{2})\/(\d{2})\/(\d{4})$/;
            return '' !== val ? regExp.test(val) : false;
         },

         acceptance: function(val, data, field) {
            return field.element.is(':checked');
         }
      },

      messages: {
         // parsley //////////////////////////////////////
         defaultMessage: "Ce champ semble non valide.",

         type: {
            email:       "Ce champ doit contenir une adresse email valide.",
            url:         "Ce champ doit contenir une URL valide.",
            urlstrict:   "Ce champ doit contenir une URL valide.",
            number:      "Ce champ doit contenir un nombre.",
            digits:      "Ce champ doit contenir une valeur numérique.",
            dateIso:     "Ce champ doit contenir une date (YYYY-MM-DD).",
            alphanum:    "Ce champ doit être alphanumérique.",
         },

         notnull:        "Ce champ ne peut pas être nulle.",
         notblank:       "Ce champ ne peut pas être vide.",
         required:       "Ce champ est requis.",
         regexp:         "Ce champ ne respecte pas le format attendu.",
         min:            "Ce champ doit contenir un nombre supérieure à %s.",
         max:            "Ce champ doit conetnir un nombre inférieur à %s.",
         range:          "Ce champ doit être comprise entre %s et %s.",
         minlength:      "Ce champ doit contenir au minimum %s caractères.",
         maxlength:      "Ce champ doit contenir au maximum %s caractères.",
         rangelength:    "Ce champ doit contenir entre %s et %s caractères.",
         equalto:        "Ce champ devrait être identique.",
         mincheck:       "Vous devez sélectionner au moins %s choix.",
         maxcheck:       "Vous devez sélectionner %s choix maximum.",
         rangecheck:     "Vous devez sélectionner entre %s et %s choix.",

         /*// parsley.extend ///////////////////////////////
         minwords:       "Cette valeur doit contenir plus de %s mots.",
         maxwords:       "Cette valeur ne peut pas dépasser %s mots.",
         rangewords:     "Cette valeur doit comprendre %s à %s mots.",
         greaterthan:    "Cette valeur doit être plus grande que %s.",
         lessthan:       "Cette valeur doit être plus petite que %s.",*/

         // Custom  //////////////////////////////
         nameformat:     "Ce champ ne peut contenir que des lettres chiffres, '_' et '-'.",
         datefr:         "Ce champ doit contenir une date selon le format (JJ/MM/AAAA).",
         acceptance:     "Vous devez accepter le %s.",
      }
   });
}(window.jQuery || window.Zepto));
