module EthilVan::App::Views

   module Member::Discussion

      class Edit < Page

         class Form < EthilVan::Mustache::Form

            def initialize(discussion)
               super(discussion)
            end

            def name
               text :name
            end

            def group
               groups = model.group.class.select('id, name').all
               groups_select = groups.each_with_object({}) do |group, hash|
                  hash[group.id] = group.name
               end
               select :new_group_id, among: groups_select
            end
         end

         def initialize(discussion)
            @form = Form.new(discussion)
         end

         def form
            @form
         end
      end
   end
end
