class EthilVan::App

   get %r{/news/(\d{1,3})/commenter$} do |id|
      news = resource News.find_by_id id

      comment = NewsComment.new
      comment.news = news
      comment.account = current_account unless guest?

      view Views::Public::News::Comment::Create.new comment, request.path
      mustache 'public/news/comment/create'
   end

   post %r{/news/(\d{1,3})/commenter$} do |id|
      news = resource News.find_by_id id

      comment = NewsComment.new
      comment.news = news
      comment.account = current_account unless guest?

      if comment.update_attributes params[:news_comment]
         redirect_not_xhr "/news/#{id}"
         view Views::Public::News::Comment::Show.new comment
         mustache 'public/news/comment/_show'
      else
         view Views::Public::News::Comment::Create.new comment, request.path
         mustache 'public/news/comment/create'
      end
   end
end
