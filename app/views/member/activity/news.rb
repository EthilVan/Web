module EthilVan::App::Views

   module Member::Activity

      class News < ActivityPartial

         def subject
            _subject.title
         end

         def subject_url
            urls.news(_subject)
         end
      end
   end
end
