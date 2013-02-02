module EthilVan::App::Views

   module Member::DiscussionGroup

      class Form < EthilVan::Mustache::ModelForm

         def initialize(group)
            super(group)
         end

         def name
            text :name, validations: {
               required: true,
            }
         end

         def url
            text :url, validations: {
               required: true,
               regexp: "^#{GeneralDiscussionGroup::URL_PATTERN}$",
            }
         end

         def priority
            text :priority, validations: {
               min: 0,
            }
         end

         def description
            text :description
         end
      end
   end
end
