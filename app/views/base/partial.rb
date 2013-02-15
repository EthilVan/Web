module EthilVan::App::Views

   module PartialHelpers

      extend ActiveSupport::Concern

      module ClassMethods

         def presence_predicate(name, method = name)
            class_eval <<-END
               def #{name}?
                  return #{method}.present?
               end
            END
         end
      end

      include EthilVan::Urls::Sinatra::Helpers
      include EthilVan::Static::Helpers
      include EthilVan::AuthHelpers

      def logged_in?
         @app.logged_in?
      end

      def guest?
         @app.guest?
      end

      def current_account
         @app.current_account
      end

      def render_markdown(text)
         @app.markdown(text)
      end
   end

   Partial = EthilVan::Mustache::Partial

   class Partial
      include PartialHelpers
   end
end
