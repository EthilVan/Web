module EthilVan::App::Views

   module Public::News

      class Index < Page

         def initialize(newses)
            @newses = newses
         end

         def redacteur?
            @redacteur = @app.current_account.role
                  .inherit? EthilVan::Role::REDACTEUR
         end

         def newses
            @newses.map { |news| NewsPartial.new(news) }
         end
      end
   end
end
