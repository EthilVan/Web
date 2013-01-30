class EthilVan::App

   get '/news' do
      page = request.xhr? ? params['page'].to_i : 1
      newses = News.with_account.by_date.page(page).per(8)
      raise Sinatra::NotFound if newses.empty?
      view Views::Public::News::Index.new newses.all
      layout !request.xhr?
      mustache 'public/news/index'
   end

   get '/news/launcher' do
      newses = News.with_account.by_date
      view Views::Public::News::Index.new newses
      layout false
      mustache 'public/news/launcher'
   end

   get '/news/feed' do
      content_type 'application/rss+xml'
      newses = News.with_account.public_only.by_date
      Views::Public::News::Feed.new(newses).to_xml
   end

   get '/news/banners' do
      content_type 'text/plain'
      private_icon = request.url.gsub(request.path, "/images/app/news/link.png")
      banners = News.public_only.has_banner.pluck 'banner'
      view Views::Public::News::Banners.new private_icon, banners
      layout false
      mustache 'public/news/banners'
   end

   get '/news/creer' do
      news = News.new
      news.account = current_account
      view Views::Public::News::Create.new news
      mustache 'public/news/create'
   end

   post '/news/creer' do
      news = News.new params[:news]
      news.account = current_account
      if news.save
         redirect urls.news news
      else
         view Views::Public::News::Create.new news
         mustache 'public/news/create'
      end
   end

   get %r{/news/(\d{1,3})$} do |id|
      news = News.find_by_id id
      raise Sinatra::NotFound if news.nil?
      halt 401 if !logged_in? and news.private
      view Views::Public::News::Show.new news
      mustache 'public/news/show'
   end
end
