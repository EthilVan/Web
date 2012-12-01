module EthilVan::App::Views

   class Member::List < Page

      def initialize(members, old_members)
         @members = members
         @old_members = old_members
      end

      def members
         @members.map { |member| {
            name: member.name,
            head: member.profil.head_url(8)
         } }
      end

      def old_members
         @old_members.map { |member| {
            name: member.name
         } }
      end
   end
end
