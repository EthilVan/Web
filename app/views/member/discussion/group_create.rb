module EthilVan::App::Views

   module Member::Discussion

      class GroupCreate < Page

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

         def initialize(group)
            @form = Form.new(group)
         end

         def form
            @form
         end
      end
   end
end
