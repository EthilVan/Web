module EthilVan::App::Views

   module Public::News::Comment

      class Form < EthilVan::Mustache::Form

         def initialize(comment, action)
            super(comment, action: action)
         end

         def member?
            @model.account?
         end

         def name
            text :name
         end

         def email
            text :email
         end

         def content
            text :content
         end

         def inline?
            @app.xhr?
         end
      end
   end
end
