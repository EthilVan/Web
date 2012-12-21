class EthilVan::App

   get '/news' do
      newses = News.with_account.by_date
      newses = newses.public_only unless logged_in?
      view Views::Public::News::Index.new newses
      mustache 'public/news/index'
   end

   get '/news/launcher' do
      newses = News.with_account.by_date
      view Views::Public::News::Index.new newses
      layout false
      mustache 'public/news/launcher'
   end

   get urls.news '(\d{1,3})' do |id|
      news = News.find_by_id id
      raise Sinatra::NotFound if news.nil?
      halt 401 if !logged_in? and news.private
      view Views::Public::News::Show.new news
      mustache 'public/news/show'
   end
end
