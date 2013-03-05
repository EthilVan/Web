class EthilVan::App < Sinatra::Base

   get '/membre' do
      activities = resources Activity.feed(current_account, params[:page])
      last_view = current_account.feed_view
      current_account.update_attribute :feed_view, Time.now

      view Views::Member::Feed::Index.new(activities, last_view)
      mustache 'membre/feed/index'
   end
end
