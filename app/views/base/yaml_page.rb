module EthilVan::App::Views

   module YamlHelpers

      def add_helpers(hash)
         return unless hash.key? 'helpers'
         hash['helpers'].each do |helper|
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

      attr_reader :yaml_url, :yaml_role, :yaml_template

      def initialize(id, hash)
         super()
         @yaml_url = '/' + (hash['url'] || id)
         @yaml_role = hash['role']
         @yaml_role &&= EthilVan::Role.get(hash['role'].to_sym)
         @yaml_template = hash['template']

         add_helpers hash

         return unless hash.key? 'onglets'
         meta_class = (class << self; self; end)
         @page_tabs = hash['onglets'].map do |id, hash|
            tab = YamlPageTab.new(self, id, hash || {})
            meta_class.send(:define_method, "tab_#{tab.tab_name}") { tab }
            tab
         end
      end

      def yaml_role?
         not @yaml_role.nil?
      end

      def yaml_tabs_url
         %r{#{@yaml_url}/(#{@page_tabs.map(&:tab_url) * '|'})/?$}
      end

      def main_tab
         @page_tabs.find &:principal?
      end
   end
end
