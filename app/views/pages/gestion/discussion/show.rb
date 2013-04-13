module EthilVan::App::Views

   module Gestion::Discussion

      class Show < Page

         def initialize(discussion_urls, discussion, page = nil)
            @discussion_urls = discussion_urls
            @discussion = discussion
            @page = page
         end

         def meta_page_title
            "#{@discussion.name}"
         end

         def discussion
            Partials::Discussion::Display.new(@discussion_urls, @discussion, @page)
         end
      end
   end
end
