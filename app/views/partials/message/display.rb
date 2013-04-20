module EthilVan::App::Views

   module Partials::Message

      class Display < Partial

         def initialize(discussion_urls, message, can_edit)
            @discussion_urls = discussion_urls
            @message = message
            @can_edit = can_edit
         end

         def discussion_name
            @message.discussion.name
         end

         def cadre
            Partials::Account::Cadre.new(@message.account)
         end

         def anchor
            "msg#{@message.id}"
         end

         def first?
            @message.first?
         end

         def view_url
            @discussion_urls.message.show(@message)
         end

         def contents
            @message.parsed_contents
         end

         def dates?
            !@message.new_record?
         end

         def created
            I18n.l @message.created_at
         end

         def updated
            I18n.l @message.updated_at
         end

         def author_signature
            @message.account.profil.parsed_signature
         end

         def can_edit?
            @can_edit
         end

         def edit_url
            @discussion_urls.message.edit(@message)
         end

         def delete_url
            @discussion_urls.message.delete(@message)
         end
      end
    end
end
