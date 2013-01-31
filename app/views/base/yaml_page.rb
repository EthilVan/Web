module EthilVan::App::Views

   module YamlHelpers

      def add_helpers(hash)
         return unless hash.key? "helpers"
         hash["helpers"].each do |helper|
            add_helper helper
         end
      end

      def add_helper(helper_token)
         helper_path = helper_token.split("::")
         helper = helper_path.inject(EthilVan::App::Views) do |mod, const|
            mod.const_get const
         end
         extend helper
      end
   end

   class YamlPage < Page

      include YamlHelpers

      attr_reader :url, :template, :tabs

      def initialize(id, hash)
         @url = '/' + (hash['url'] || id)
         @template = hash['template']
         @page_title = hash['titre']
         @page_title = [ @page_title ] unless @page_title.is_a? Array

         add_helpers hash

         return unless hash.key? 'onglets'
         @main_tab = @url + '/' + hash['principal']
         meta_class = (class << self; self; end)
         @tabs = hash['onglets'].map do |id, hash|
            tab = YamlTab.new(self, id, hash)
            meta_class.send(:define_method, "tab_#{tab.id}") { tab }
            tab
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

      include YamlHelpers

      attr_reader :id, :url, :name, :tab_title

      def initialize(page, id, hash)
         @id = id
         @name = hash['nom']
         @tab_title = @name + ' | ' + page.meta_page_title
         @url = page.url + '/' + (hash['url'] || id)
         add_helpers hash
      end
   end
end
