module EthilVan::Mustache

   class Page < Partial

      def stylesheet_name
         path = app.request.path
         path =~ %r{^/m(embre|oderation)} ? "member" : "app"
      end

      def javascript_name
         path = app.request.path
         if path =~ %r{^/m(embre|oderation)} or app.logged_in?
            "member"
         else
            "app"
         end
      end
   end
end
