class EthilVan::App < Sinatra::Base

   YamlPages = []
   EthilVan.load_datas("pages").each do |data|
       data.each do |id, hash|
         YamlPages << EthilVan::Mustache::YamlPage.new(id, hash)
      end
   end

   YamlPages.each do |yaml_page|
      if yaml_page.tabs?
         get yaml_page.url do
            redirect yaml_page.main_tab_url
         end

         for tab in yaml_page.tabs do
            get tab.url do
               view yaml_page
               mustache yaml_page.template
            end
         end
      else
         get yaml_page.url do
            view yaml_page
            mustache yaml_page.template
         end
      end
   end
end
