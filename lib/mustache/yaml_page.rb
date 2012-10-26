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

      def respond_to?(name)
         return super(name) || name =~ /^tab_/
      end

      def method_missing(name, *args)
         if name =~ /^tab_(.+)$/
            return @tabs.find { |tab| tab.id == $1 }
         else
            super(name, *args)
         end
      end
   end

   class YamlTab < Partial

      attr_reader :id, :url, :name

      def initialize(page, id, hash)
         @id = id
         @name = hash["nom"]
         @url = page.url + "/" + (hash["url"] || id)

         if hash.key? "helpers"
            hash["helpers"].each do |helper_token|
               helper_path = helper_token.split("::")
               helper = helper_path.inject(EthilVan::Helpers) do |mod, const|
                  mod.const_get const
               end
               extend helper
            end
         end
      end
   end
end
