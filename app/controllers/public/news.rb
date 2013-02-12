class EthilVan::App

   get '/news' do
      newses = resources News.with_account.by_date.
            page(params[:page]).per(8)
      view Views::Public::News::List.new newses.all
      mustache 'public/news/list'
   end

   get '/news/launcher' do
      newses = News.with_account.by_date
      layout false
      view Views::Public::News::List.new newses
      mustache 'public/news/launcher'
   end

   get '/news/feed' do
      content_type 'application/rss+xml'
      newses = News.with_account.public_only.by_date
      Views::Public::News::Feed.new(newses).to_xml
   end

   get %r{/news/(?:images|banners)$} do
      content_type 'text/plain'
      private_icon = request.url.gsub(request.path,
         EthilVan::Static::Helpers.asset('images/app/news/link.png'))
      banners = News.public_only.has_banner.pluck 'banner'
      view Views::Public::News::Images.new private_icon, banners
      layout false
      mustache 'public/news/images'
   end

   protect %r{^/news/creer$}, EthilVan::Role::REDACTEUR

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
      news = resource News.find_by_id id
      not_authorized if news.private and guest?
      view Views::Public::News::Show.new news
      mustache 'public/news/show'
   end

   protect %r{^/news/\d{1,3}/editer$},    EthilVan::Role::REDACTEUR
   protect %r{^/news/\d{1,3}/supprimer$}, EthilVan::Role::REDACTEUR

   get %r{/news/(\d{1,3})/editer$} do |id|
      news = resource News.find_by_id id
      view Views::Public::News::Edit.new news
      mustache 'public/news/edit'
   end

   post %r{/news/(\d{1,3})/editer$} do |id|
      news = resource News.find_by_id id

      if news.update_attributes params[:news]
         redirect urls.news news
      else
         view Views::Public::News::Edit.new news
         mustache 'public/news/edit'
      end
   end

   get %r{/news/(\d{1,3})/supprimer$} do |id|
      news = resource News.find_by_id id
      news.destroy
      xhr_ok_or_redirect '/news'
   end
end
