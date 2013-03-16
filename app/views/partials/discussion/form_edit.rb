module EthilVan::App::Views

   module Partials::Discussion

      class EditForm < EthilVan::Mustache::Form

         def initialize(discussion)
            super(discussion)
         end

         def name
            text :name
         end

         def archived
            boolean :archived
         end

         def group
            groups = model.group.class.by_priority.select('id, name').all
            groups_select = groups.each_with_object({}) do |group, hash|
               hash[group.id] = group.name
            end
            choice :new_group_id, among: groups_select
         end
      end
   end
end
