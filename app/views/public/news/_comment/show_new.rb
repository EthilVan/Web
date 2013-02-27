module EthilVan::App::Views

   module Public::News::Comment

      class ShowNew < Show

         def comment_url
            "/news/#{@comment.news.id}/commenter"
         end
      end
   end
end
