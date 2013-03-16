module EthilVan::App::Views

   module Partials::Discussion

      class Pager < Partial

         AROUND = 4
         TOTAL = 2 * AROUND + 1

         def initialize(discussion, page)
            @last_message_id = discussion.last_message.id
            @base_url = "/membre/discussion/#{discussion.id}"
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
            page_link(1)
         end

         def previous
            page_link(current - 1)
         end

         def next
            page_link(current + 1)
         end

         def last
            page_link(total)
         end

         def last_message?
            true
         end

         def last_message
            "#{last}#msg#{@last_message_id}"
         end

         def pages
            @first.upto(@last).map do |i|
               { i: i, url: page_link(i), selected: i == current }
            end
         end

      private

         def page_link(page)
            "#@base_url?page=#{page}"
         end
      end
   end
end
