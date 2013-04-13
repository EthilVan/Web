module EthilVan::App::Views

   module Public::News::Comment

      class ShowNew < Show

         def commentable
            @comment.news.commentable
         end

         def comment_url
            urls::Public::News::Comment.create(@comment.news)
         end
      end
   end
end
