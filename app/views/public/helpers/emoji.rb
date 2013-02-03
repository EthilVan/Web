module EthilVan::App::Views

   module Help
      module Emoji

         def emojis
            EthilVan::Emoji.names.map { |emoji| {
               name: emoji,
               path: "/images/emoji/#{emoji}.png"
            } }
         end
      end
   end
end
