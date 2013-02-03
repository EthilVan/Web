module EthilVan::App::Views

   module Member::DiscussionGroup

      class DiscussionPreview < Partial

         def initialize(discussion, current_account)
            @discussion = discussion
            messages = discussion.messages
            @first_message = messages.first
            @last_message = messages.last
            @url = "/membre/discussion/#{discussion.id}"
            @account = current_account
         end

         def url
            @url
         end

         def delete_url
            "#@url/supprimer"
         end

         def status_class
            @discussion.read_by?(@account) ? 'read' : 'unread'
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
            urls.profil @first_message.account
         end

         def last_message_link
            "/membre/message/#{@last_message.id}"
         end

         def last_message
            I18n.l @discussion.updated_at
         end

         def last_author
            @last_message.account.name
         end

         def last_author_link
            urls.profil @last_message.account
         end
      end
   end
 end
