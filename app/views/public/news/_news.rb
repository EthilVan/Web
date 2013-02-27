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

         def _categories
            @categories ||= @news.categories.to_a
         end

         def categories_data
            _categories * ' '
         end

         def categories?
            _categories.size > 0
         end

         def categories
            _categories.map do |category|
               EthilVan::Data::News::Categories[category.to_s]
            end
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

         def summary
            @news.parsed_summary
         end

         def contents
            @news.parsed_contents
         end

         def created
            I18n.l @news.created_at
         end

         def updated?
            @news.updated_at > @news.created_at
         end

         def updated
            I18n.l @news.updated_at
         end

         def comments?
            comments_count > 0
         end

         def comments_count
            @comments_count ||= @news.comments.size
         end

         def comments_plural?
            comments_count > 1
         end

         def comments
            @news.comments.map do |comment|
               Comment::Show.new(comment)
            end
         end
      end
   end
end
