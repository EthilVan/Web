class EthilVan::App

   get '/news' do
      page = Views::Page.new
      def page.newses
         @app.markdown(News.first(conditions: { id: 26 }).contents)
      end
      view page
      mustache 'public/news/liste'
   end
end
