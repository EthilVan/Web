module EthilVan::App::Views

   class Page < Partial

      def page_title
         return 'Ethil Van' if @page_title.blank?
         @page_title * ' - '
      end

      def meta_page_title
         return 'Ethil Van' if @page_title.blank?
         @page_title.reverse * ' | ' + ' | Ethil Van'
      end

      def title(text)
         @page_title = text.split(',')
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
         !(path =~ %r{^/(?:membre|gestion)}).nil?
      end

      def stylesheet
         name = member_page? ? 'member' : 'app'
         asset "style/#{name}.css"
      end

      def javascript
         name = logged_in? ? 'member' : 'app'
         asset "scripts/#{name}.js"
      end

      def member_menu?
         member_page?
      end
   end

   module Public
   end

   module Member
   end

   module Gestion
   end
end
