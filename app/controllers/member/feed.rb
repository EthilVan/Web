class EthilVan::App < Sinatra::Base

   get '/membre/?' do
      activities = resources Activity.feed(current_account, params[:page])
      last_view = current_account.feed_view

      job = EthilVan::Jobs::UpdateFeedView.new(current_account, Time.now)
      EthilVan::Jobs.push(job)

      view Views::Member::Feed.new(activities, last_view)
      mustache 'membre/feed'
   end
end
