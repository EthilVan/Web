class NewsObserver < ActiveRecord::Observer

   def after_create(news)
      Activity.create_for(news.account, 'create', news)
   end

   def after_update(news)
      return unless news.important
      Activity.create_for(news.activity_actor, 'edit', news)
   end
end

ActiveRecord::Base.observers << NewsObserver
