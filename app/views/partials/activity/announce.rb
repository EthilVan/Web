module EthilVan::App::Views

   module Member::Activity

      class Announce < ActivityPartial

         def subject_content
            _subject.parsed_content
         end
      end
   end
end
