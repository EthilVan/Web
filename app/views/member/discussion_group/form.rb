module EthilVan::App::Views

   module Member::DiscussionGroup

      class Form < EthilVan::Mustache::ModelForm

         def initialize(group)
            super(group)
         end

         def name
            text :name
         end

         def url
            text :url
         end

         def priority
            text :priority
         end

         def description
            text :description
         end
      end
   end
end
