class EthilVan::App

   get %r{/news/(\d{1,3})/commenter/?$} do |id|
      news = resource News.find_by_id id
      raise not_found unless news.commentable

      comment = NewsComment.new
      comment.news = news
      comment.account = current_account unless guest?

      view Views::Public::News::Comment::Create.new comment, request.path
      mustache 'public/news/comment/create'
   end

   post %r{/news/(\d{1,3})/commenter/?$} do |id|
      news = resource News.find_by_id id
      raise not_found unless news.commentable

      comment = NewsComment.new
      comment.news = news
      comment.account = current_account unless guest?

      if comment.update_attributes params[:news_comment]
         redirect_not_xhr urls.news(comment.news)
         view Views::Public::News::Comment::ShowNew.new comment
         mustache 'public/news/comment/show_new'
      else
         view Views::Public::News::Comment::Create.new comment, request.path
         mustache 'public/news/comment/create'
      end
   end

   get %r{/news/commentaire/(\d{1,7})/editer/?$} do |id|
      comment = resource NewsComment.find_by_id id
      not_authorized unless modo? or current?(comment.account)

      view Views::Public::News::Comment::Edit.new comment, request.path
      mustache 'public/news/comment/edit'
   end

   post %r{/news/commentaire/(\d{1,7})/editer/?$} do |id|
      comment = resource NewsComment.find_by_id id
      not_authorized unless modo? or current?(comment.account)

      if comment.update_attributes params[:news_comment]
         redirect urls.news(comment.news)
      else
         view Views::Public::News::Comment::Edit.new comment, request.path
         mustache 'public/news/comment/edit'
      end
   end

   get %r{/news/commentaire/(\d{1,7})/supprimer/?$} do |id|
      comment = resource NewsComment.find_by_id id
      not_authorized unless modo? or current?(comment.account)

      comment.destroy
      xhr_ok_or_redirect urls.news(comment.news)
   end
end
