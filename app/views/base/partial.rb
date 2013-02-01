module EthilVan::App::Views

   class Partial < EthilVan::Mustache::Partial

      include EthilVan::Urls::Sinatra::Helpers

      def self.presence_predicate(name, method = name)
        class_eval <<-END
          def #{name}?
            return #{method}.present?
          end
        END
      end

      def logged_in?
         app.logged_in?
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
end
