module EthilVan::App::Views

   module Member::Activity

      class NewsComment < ActivityPartial

         def member?
            _subject.account?
         end

         def anonymous_name
            _subject.name
         end

         def subject_news
            _subject.news.title
         end

         def subject_news_url
            urls::Public::News.show(_subject.news)
         end
      end
   end
end
