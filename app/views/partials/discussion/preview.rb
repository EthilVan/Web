module EthilVan::App::Views

   module Partials::Discussion

      class Preview < Partial

         def initialize(discussion, current_account, views)
            @discussion = discussion
            @first_message = discussion.first_message
            @last_message = discussion.last_message
            @account = current_account
            @viewed = discussion.archived? || viewed?(views)
         end

         def url
            urls::Member::Discussion.show(@discussion)
         end

         def status_class
            @viewed ? 'read' : 'unread'
         end

         def edit_url
            urls::Member::Discussion.edit(@discussion)
         end

         def delete_url
            urls::Member::Discussion.delete(@discussion)
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
            urls::Member::Message.show(@last_message)
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

      private

         def viewed?(views)
            view = views[nil]
            return true if !view.nil? and view.first > @discussion
            view = views[@discussion.id]
            return (!view.nil? and view.first > @discussion)
         end
      end
   end
 end
