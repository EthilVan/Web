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

      def render_markdown(text)
         @app.markdown(text)
      end

   end
end
