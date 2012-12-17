module EthilVan::App::Views

   class Partial < EthilVan::Mustache::Partial

      def logged_in?
         app.logged_in?
      end

      def render_markdown(text)
         @app.markdown(text)
      end
   end
end
