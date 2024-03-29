class EthilVan::Mustache::Form

   module FieldContainer

      def compute_field_name(name)
         _names = [*field_names, name]
         _names.shift + '[' + (_names * '][') + ']'
      end

      def compute_field_id(id)
         [*field_ids, id] * '_'
      end

      def l10n_for(field, *data)
         i18n_namespaces.each do |ns|
            data = _l10n_for(ns, field, *data)
            return data unless data.nil?
         end

         return nil
      end

      def label_for(field)
         l10n_for(field, :label) || model.class.human_attribute_name(field)
      end

   private

      def _l10n_for(ns, field, *data)
         I18n.translate!(["form", ns, *data, field] * '.')
      rescue I18n::MissingTranslationData
         nil
      end
   end
end
