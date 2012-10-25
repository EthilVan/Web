class EthilVan::App < Sinatra::Base

   YamlPages = []
   EthilVan.load_datas("pages").each do |data|
       data.each do |id, hash|
         YamlPages << EthilVan::Mustache::YamlPage.new(id, hash)
      end
   end

   YamlPages.each do |static_page|
      if static_page.tabs?
         get static_page.url do
            redirect static_page.main_tab_url
         end

         for tab in static_page.tabs do
            get tab.url do
               view static_page
               mustache static_page.template
            end
         end
      else
         get static_page.url do
            view static_page
            mustache static_page.template
         end
      end
   end
end
