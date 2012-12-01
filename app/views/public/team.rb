module EthilVan::Helpers

   module Public

      module Team

         class Member

            def initialize(account)
               @account = account
            end

            def name
               @account.name
            end

            def avatar
               @account.profil.avatar_url
            end

            def description
               @account.profil.description
            end
         end

         class Role

            attr :description

            def initialize(role, desc)
               @role = role
               @description = desc
               @members = Account.where(:role_id => @role.id).map do |account|
                  Member.new account
               end
            end

            def role_name
               @role.name
            end

            def members?
               !@members.empty?
            end

            def members
               @members
            end
         end

         descriptions = EthilVan.load_data("public", "team")
         Descriptions = descriptions.map do |id, desc|
            role = EthilVan::Role.get id.to_sym
            Role.new(role, desc)
         end

         def roles
            Descriptions
         end
      end
   end
end
