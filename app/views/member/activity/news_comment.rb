module EthilVan::App::Views

   module Member::Activity

      class NewsComment < ActivityPartial

         def subject_news
            _subject.news.title
         end

         def subject_news_url
            urls.news(_subject.news)
         end
      end
   end
end
