module EthilVan::App::Views

   module Member::Discussion

      class Message < Member::Message::Show

         def initialize(message, index, stats_max = nil)
            super(message, index, stats_max)
         end

         def can_edit
            false
         end
      end
   end
end
