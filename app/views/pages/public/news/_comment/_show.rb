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

         def content
            @comment.parsed_content
         end

         def editable?
            modo? or current?(@comment.account)
         end

         def anchor
            "comment-#{@comment.id}"
         end

         def base_url
            "/news/commentaire/#{@comment.id}"
         end

         def edit_url
            "#{base_url}/editer"
         end

         def delete_url
            "#{base_url}/supprimer"
         end
      end
   end
end
