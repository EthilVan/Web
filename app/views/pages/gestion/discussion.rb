module EthilVan::App::Views

   module Gestion::Message

      class Create < Base::Message::Create
      end

      class Edit < Base::Message::Edit
      end
   end

   module Gestion::Discussion

      class Create < Base::Discussion::Create
      end

      class Edit < Base::Discussion::Edit
      end

      class Show < Base::Discussion::Show
      end
   end

   module Gestion::DiscussionGroup

      class Create < Base::DiscussionGroup::Create
      end

      class Edit < Base::DiscussionGroup::Edit
      end

      class List < Base::DiscussionGroup::List
      end

      class Show < Base::DiscussionGroup::Show
      end
   end
end
