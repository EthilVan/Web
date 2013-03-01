class NewsCommentObserver < ActiveRecord::Observer

   def after_create(comment)
      Activity.create_for(comment.account, 'create', comment)
   end
end

ActiveRecord::Base.observers << NewsCommentObserver
