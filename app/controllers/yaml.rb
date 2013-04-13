class EthilVan::App < Sinatra::Base

   def self.define_simple_page(page)
      get "#{page.yaml_url}/?" do
         view page
         mustache page.yaml_template
      end
   end

   def self.define_page_with_tabs(page)
      get "#{page.yaml_url}/?" do
         redirect page.main_tab.tab_complete_url
      end

      get "#{page.yaml_tabs_url}/?" do |tab|
         view page
         mustache page.yaml_template
      end
   end

   EthilVan.load_datas('pages').each do |data|
       data.each do |id, hash|
         yaml_page = Views::YamlPage.new(id, hash)
         if yaml_page.page_tabs?
            define_page_with_tabs yaml_page
         else
            define_simple_page yaml_page
         end
      end
   end
end
