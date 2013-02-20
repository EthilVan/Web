module EthilVan::App::Views

   class PageTab < Partial

      def initialize(page, name)
         @page = page
         @name = name
         @tab_title = name.capitalize
      end

      def tab_name
         @name
      end

      def tab_title
         lambda do |text|
            @tab_title = text
            nil
         end
      end

      def get_tab_title
         @tab_title
      end

      def meta_tab_title
         [@tab_title, @page.meta_page_title] * ' | '
      end

      def active?
         !(app.request.path_info =~ %r{/#{@name}$}).nil?
      end

      def tab_status
         active? ? ' active' : ''
      end
   end
end
