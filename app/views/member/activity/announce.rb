module EthilVan::App::Views

   module Member::Activity

      class Announce < ActivityPartial

         def subject_content
            _subject.content
         end
      end
   end
end
