module EthilVan::App::Views

   module Member::Profil::Edit

      class Generale < Partial

         class Form < EthilVan::Mustache::Form

            def initialize(account, action)
               super(account, action: action)
            end
         end

         def initialize(account)
            @form = Form.new(account, urls.profil_edit('generale', account))
         end

         def form
            @form
         end
      end
   end
end
