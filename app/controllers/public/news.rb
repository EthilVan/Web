class EthilVan::App

   get '/news' do
      newses = News.with_account.ordered
      newses = newses.public unless logged_in?
      view Views::Public::News::Index.new newses
      mustache 'public/news/index'
   end

   get %r{/news/(\d{1,3})$} do |id|
      news = News.find_by_id id
      raise Sinatra::NotFound if news.nil?
      halt 401 if !logged_in? and news.private
      view Views::Public::News::Show.new news
      mustache 'public/news/show'
   end
end
