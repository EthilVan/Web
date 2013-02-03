#encoding: utf-8

module EthilVan::App::Views

   module Member::Profil

      class Tabs < Page

         TABS = [
            { id: 'generale',    name: 'Générale'    },
            { id: 'postulation', name: 'Postulation' },
            { id: 'tags',        name: 'Tags'        },
            { id: 'messages',    name: 'Messages'    },
         ]


         def initialize(account, messages)
            @account = account
            @messages = messages
         end

         def meta_page_title
            "@#{@account.name} | Ethil Van"
         end

         def tabs?
            true
         end

         def tabs
            base_title = meta_page_title
            TABS.map do |tab_proto|
               tab = tab_proto.clone
               tab[:tab_title] = tab[:name] + ' | ' + base_title
               tab
            end
         end

         def tab_generale
            Generale.new(@account)
         end

         def postulation?
            true
         end

         def tab_postulation
            Postulation.new(@account.postulation)
         end

         def tab_tags
            Tags.new(@account.profil_tags)
         end

         def tab_messages
            Messages.new(@account, @messages)
         end
      end
   end
end
