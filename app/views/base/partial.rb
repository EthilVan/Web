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

      def logged_in?
         @app.logged_in?
      end

      def guest?
         @app.guest?
      end

      def has_role?(role)
         @app.current_account.role.inherit?(role)
      end

      def modo?
         @has_role_modo ||= has_role?(EthilVan::Role::MODO)
      end

      def redacteur?
         @has_role_redacteur ||= has_role?(EthilVan::Role::REDACTEUR)
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
