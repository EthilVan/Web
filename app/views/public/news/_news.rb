module EthilVan::App::Views

   module Public::News

      class NewsPartial < Partial

         def initialize(news)
            @news = news
         end

         def url
            urls.news @news
         end

         def edit_url
            "#{urls.news @news}/editer"
         end

         def delete_url
            "#{urls.news @news}/supprimer"
         end

         def title
            @news.title
         end

         def banner_url
            @news.banner
         end

         def author
            @news.account.name
         end

         def private?
            @news.private
         end

         def logged_in?
            @logged_in ||= @app.logged_in?
         end

         def show?
            !private? or logged_in?
         end

         def important_class
            @news.important ? 'important' : ''
         end

         def summary
            @news.parsed_summary
         end

         def contents
            @news.parsed_contents
         end

         def created
            I18n.l @news.created_at
         end
      end
   end
end
