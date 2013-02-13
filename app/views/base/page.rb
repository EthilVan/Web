module EthilVan::App::Views

   class Page < Partial

      STYLESHEET = EthilVan::Static::Helpers.asset 'app.css'
      JAVASCRIPT = EthilVan::Static::Helpers.asset 'app.js'

      def page_title
         lambda do |text|
            @page_title = text.split(',')
            nil
         end
      end

      def _page_title
         @page_title ||= []
      end

      def page_title?
         _page_title.present?
      end

      def get_page_title
         _page_title
      end

      def meta_page_title
         [*_page_title.reverse, 'Ethil Van'] * ' | '
      end

      def page_description
         lambda do |text|
            @page_description = text
            nil
         end
      end

      def page_description?
         @page_description.present?
      end

      def get_page_description
         @page_description
      end

      def page_tabs?
         page_tabs.present?
      end

      def page_tabs
         @page_tabs ||= []
      end

      def stylesheet
         name = member_page? ? 'member' : 'app'
         asset "style/#{name}.css"
      end

      def javascript
         JAVASCRIPT
      end

      def member_page?
         path = app.request.path
         !(path =~ %r{^/(?:membre|gestion)}).nil?
      end

      def data_logged_in
         logged_in? ? 'member' : 'guest'
      end

      def button_server_url
         '/presentation'
      end

      def button_member_url
         logged_in? ? '/membre' : '/login'
      end

      def submenu_server_visibility
         member_page? ? ' submenu-hidden' : ' submenu-visible'
      end

      def submenu_member_visibility
         member_page? ? ' submenu-visible' : ' submenu-hidden'
      end
   end

   module Public
   end

   module Member
   end

   module Gestion
   end
end
