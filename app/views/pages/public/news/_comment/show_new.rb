module EthilVan::App::Views

   module Public::News::Comment

      class ShowNew < Show

         def commentable
            @comment.news.commentable
         end

         def comment_url
            "/news/#{@comment.news.id}/commenter"
         end
      end
   end
end
