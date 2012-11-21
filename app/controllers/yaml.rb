class EthilVan::App < Sinatra::Base

   def self.define_simple_page(page)
      get page.url do
         view page
         mustache page.template
      end
   end

   def self.define_page_with_tabs(page)
      get page.url do
         redirect page.main_tab_url
      end

      for tab in page.tabs do
         get tab.url do
            view page
            mustache page.template
         end
      end
   end

   EthilVan.load_datas("pages").each do |data|
       data.each do |id, hash|
         yaml_page = Views::YamlPage.new(id, hash)
         if yaml_page.tabs?
            define_page_with_tabs yaml_page
         else
            define_simple_page yaml_page
         end
      end
   end
end
