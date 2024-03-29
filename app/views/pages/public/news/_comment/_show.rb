require 'digest/md5'

module EthilVan::App::Views

   module Public::News::Comment

      class Show < Partial

         def initialize(comment)
            @comment = comment
         end

         def member?
            @comment.account?
         end

         def member_name
            @comment.account.name
         end

         def member_avatar
            @comment.account.profil.avatar
         end

         def author_name
            @comment.name
         end

         def author_email
            @comment.email
         end

         def author_avatar
            md5hash = Digest::MD5.hexdigest author_email
            "http://www.gravatar.com/avatar/#{md5hash}"
         end

         def created_at
            I18n.l @comment.created_at
         end

         def content
            @comment.parsed_content
         end

         def editable?
            modo? or current?(@comment.account)
         end

         def anchor
            "comment-#{@comment.id}"
         end

         def edit_url
            urls::Public::News::Comment.edit(@comment)
         end

         def delete_url
            urls::Public::News::Comment.delete(@comment)
         end
      end
   end
end
