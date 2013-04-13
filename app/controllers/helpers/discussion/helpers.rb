class EthilVan::App

   module Helpers::DiscussionRoutes

      extend ActiveSupport::Concern

      included do

         helpers do

            def discussion_url(message, discussion = message.discussion, page = nil)
               page ||= message.page
               page = nil if page < 1
               urls::Member::Discussion.show(message.discussion, page, message)
            end

            def new_messages(discussion, last_message_id)
               return [] if last_message_id.nil? or
                     discussion.last_message(true).id == last_message_id

               messages = discussion.messages
               index = messages.index { |msg| msg.id == last_message_id }
               return [] if index.nil?
               messages[(index + 1)..-1]
            end
         end
      end

      module ClassMethods
      protected

         def discussion_group_base_url(base_url)
            "#{base_url}/(#{DiscussionGroup::URL_PATTERN})"
         end

         def discussion_base_url(base_url)
            "#{base_url}/(\\d{1,5})"
         end

         def message_base_url(base_url)
            "#{base_url}/:id"
         end
      end
   end

   include Helpers::DiscussionRoutes
end
