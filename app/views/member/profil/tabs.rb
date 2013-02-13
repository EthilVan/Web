module EthilVan::App::Views

   module Member::Profil

      class Tabs < Page

         def initialize(account, new_tag, tags, messages)
            @account = account
            @tab_general     = General.new(    self, account)
            @tab_postulation = Postulation.new(self, account.postulation)
            @tab_tags        = Tags.new(       self, account, new_tag, tags)
            @tab_messages    = Messages.new(   self, account, messages)
         end

         def _page_title
            @page_title ||= [current?(@account) ? 'Profil' : ('@' + @account.name)]
         end

         def page_tabs
            @page_tabs ||= [
               @tab_general, @tab_postulation, @tab_tags, @tab_messages
            ]
         end

         def tab_general
            @tab_general
         end

         def tab_postulation
            @tab_postulation
         end

         def tab_tags
            @tab_tags
         end

         def tab_messages
            @tab_messages
         end
      end
   end
end
