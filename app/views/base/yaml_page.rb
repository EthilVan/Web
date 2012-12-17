module EthilVan::App::Views

   class YamlPage < Page

      attr_reader :url, :template, :tabs

      def initialize(id, hash)
         @url = '/' + (hash['url'] || id)
         @template = hash['template']
         @page_title = hash['titre']
         @page_title = [ @page_title ] unless @page_title.is_a? Array

         if hash.key? 'onglets'
            @main_tab = @url + '/' + hash['principal']
            meta_class = (class << self; self; end)
            @tabs = hash['onglets'].map do |id, hash|
               tab = YamlTab.new(self, id, hash)
               meta_class.send(:define_method, "tab_#{tab.id}") { tab }
               tab
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

   class YamlTab < EthilVan::Mustache::Partial

      attr_reader :id, :url, :name

      def initialize(page, id, hash)
         @id = id
         @name = hash['nom']
         @url = page.url + '/' + (hash['url'] || id)

         if hash.key? 'helpers'
            hash['helpers'].each do |helper_token|
               helper_path = helper_token.split('::')
               helper = helper_path.inject(EthilVan::App::Views) do |mod, const|
                  mod.const_get const
               end
               extend helper
            end
         end
      end
   end
end
