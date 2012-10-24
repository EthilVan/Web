module EthilVan::Mustache

   class YamlPage < Page

      attr_reader :url, :template, :title, :tabs

      def initialize(id, hash)
         @url = "/" + (hash["url"] || id)
         @template = hash["template"]
         @title = hash["titre"]

         if hash.key? "onglets"
            @main_tab = @url + "/" + hash["principal"]
            @tabs = hash["onglets"].map do |id, hash|
               YamlTab.new(self, id, hash)
            end
         end
      end

      def tabs?
         @tabs != nil
      end

      def main_tab_url
         @main_tab
      end
   end

   class YamlTab < Partial

      attr_reader :url, :name

      def initialize(page, id, hash)
         @name = hash["nom"]
         @url = page.url + "/" + (hash["url"] || id)
      end
   end
end
