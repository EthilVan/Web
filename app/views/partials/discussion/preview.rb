module EthilVan::App::Views

   module Partials::Discussion

      class Preview < Partial

         def initialize(discussion_urls, discussion, current_account, views)
            @discussion_urls = discussion_urls
            @discussion = discussion
            @first_message = discussion.first_message
            @last_message = discussion.last_message
            @account = current_account
            @viewed = discussion.archived? || views.include?(discussion)
         end

         def status_class
            @viewed ? 'read' : 'unread'
         end

         def url
            @discussion_urls.discussion.show(@discussion)
         end

         def edit_url
            @discussion_urls.discussion.edit(@discussion)
         end

         def delete_url
            @discussion_urls.discussion.delete(@discussion)
         end

         def name
            @discussion.name
         end

         def created
            I18n.l @discussion.created_at
         end

         def author
            @first_message.account.name
         end

         def author_link
            urls::Member::Profil.show(@first_message.account)
         end

         def last_message_link
            @discussion_urls.message.show(@last_message)
         end

         def last_message
            I18n.l @discussion.updated_at
         end

         def last_author
            @last_message.account.name
         end

         def last_author_link
            urls::Member::Profil.show(@last_message.account)
         end
      end
   end
 end
