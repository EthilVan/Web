module EthilVan::App::Views

   module Partials::Discussion

      class Pager < Partial

         AROUND = 4
         TOTAL = 2 * AROUND + 1

         def initialize(discussion, page)
            @discussion = discussion
            @last_message = discussion.last_message

            @page = page
            @first = [1,     current - AROUND].max
            @last  = [total, current + AROUND].min
         end

         def current
            @current ||= @page.current_page
         end

         def total
            @total ||= @page.total_pages
         end

         def first?
            @first > 1
         end

         def previous?
            current > 1
         end

         def next?
            current < total
         end

         def last?
            @last < total
         end

         def first
            page_url(1)
         end

         def previous
            page_url(current - 1)
         end

         def next
            page_url(current + 1)
         end

         def last
            page_url(total)
         end

         def last_message?
            true
         end

         def last_message
            page_url(total, @last_message)
         end

         def pages
            @first.upto(@last).map do |i|
               { i: i, url: page_url(i), selected: i == current }
            end
         end

      private

         def page_url(page, message = nil)
            urls::Member::Discussion.show(@discussion, page, message)
         end
      end
   end
end
