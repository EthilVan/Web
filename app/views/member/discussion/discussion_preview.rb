# encoding: utf-8

module EthilVan::App::Views

   module Member::Discussion

      class DiscussionPreview < Partial

         def initialize(discussion, current_account)
            @discussion = discussion
            messages = discussion.messages
            @first_message = messages.first
            @last_message = messages.last
            @url = "/membre/discussion/#{discussion.id}"
            @account = current_account
         end

         def profil_link(author_name)
            "/membre/@#{author_name}"
         end

         def url_discussion
            @url
         end

         def status_class
            @discussion.read_by?(@account) ? 'read' : 'unread'
         end

         def name
            @discussion.name
         end

         def created
            @discussion.created_at.strftime('%d/%m/%Y à %H:%M')
         end

         def author
            @first_message.account.name
         end

         def author_link
            profil_link author
         end

         def last_message_link
            ''
            #"#{@url}?page=#{@discussion.total_pages}#msg#{@last_message.id}"
         end

         def last_message
            @discussion.updated_at.strftime('%d/%m/%Y à %H:%M')
         end

         def last_author
            @last_message.account.name
         end

         def last_author_link
            profil_link last_author
         end
      end
   end
 end