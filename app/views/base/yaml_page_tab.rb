module EthilVan::App::Views

   class YamlPageTab < PageTab

      include YamlHelpers

      attr_reader :tab_url

      def initialize(page, id, hash)
         super(page, id)
         @principal = hash['principal']
         @tab_url = hash['url'] || id
         add_helpers hash
      end

      def principal?
         @principal
      end

      def tab_complete_url
         @page.yaml_url + '/' + @tab_url
      end
   end
end
