module EthilVan::App::Views

   class Page < EthilVan::Mustache::Partial

      def page_title
         @page_title || "Ethil Van"
      end

      def meta_page_title
         @page_title ? @page_title + " | Ethil Van" : "Ethil Van"
      end

      def title(text)
         @page_title = text
         nil
      end

      def page_description?
         !@page_description.nil?
      end

      def get_page_description
         @page_description
      end

      def page_description(text)
         @page_description = text
         nil
      end

      def member_page?
         path = app.request.path
         !(path =~ %r{^/m(embre|oderation)}).nil?
      end

      def logged_in?
         app.logged_in?
      end

      def stylesheet_name
         member_page? ? "member" : "app"
      end

      def javascript_name
         logged_in? ? "member" : "app"
      end

      def member_menu?
         member_page?
      end
   end
end
