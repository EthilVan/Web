module EthilVan::App::Views

   class Partial < EthilVan::Mustache::Partial

      def render_markdown(text)
         @app.markdown(text)
      end
   end
end
