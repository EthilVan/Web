module EthilVan::App::Views

   module Member::Discussion

      class Show < Page

         def initialize(discussion, page = nil)
            @discussion = discussion
            @page = page
         end

         def meta_page_title
            "#{@discussion.name}"
         end

         def discussion
            Partials::Discussion::Display.new(@discussion, @page)
         end
      end
   end
end
