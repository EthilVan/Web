module EthilVan::App::Views

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
            end

            def role_name
               @role.name
            end

            def members?
               Account.where(role_id: @role.id).exists?
            end

            def members
               @members = Account.with_profil.where(role_id: @role.id).map do |account|
                  Member.new account
               end
            end
         end

         @@roles = EthilVan.load_data('public', 'team').map do |id, desc|
            role = EthilVan::Role.get id.to_sym
            Role.new(role, desc)
         end

         def roles
            @@roles
         end
      end
   end
end
