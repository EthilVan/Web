class EthilVan::App < Sinatra::Base

   get '/membre' do
      activities = Activity.feed(current_account)
      view Views::Member::Feed::Index.new(activities)
      mustache 'membre/feed/index'
   end
end
