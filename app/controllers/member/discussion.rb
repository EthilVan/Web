class EthilVan::App < Sinatra::Base

   get '/membre/discussion' do
      groups = GeneralDiscussionGroup.by_priority
      view Views::Member::Discussion::Index.new groups
      mustache 'membre/discussion/index'
   end

   get '/membre/discussion/!toutes_lues' do
      DiscussionView.mark_all_read_for(current_account)
      redirect '/membre/discussion'
   end

   get %r{/membre/discussion/([A-Za-z_]+)$} do |group_name|
      group = GeneralDiscussionGroup.find_by_url group_name
      raise Sinatra::NotFound if group.nil?
      view Views::Member::Discussion::DiscussionGroup.new(group)
      mustache 'membre/discussion/discussion_group'
   end

   get %r{/membre/discussion/(\d{1,5})$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      page = discussion.page(params[:page]).
            includes(account: [ :profil, :minecraft_stats ])
      raise Sinatra::NotFound unless page.present?
      DiscussionView.update_for(current_account, discussion)
      view Views::Member::Discussion::Discussion.new(discussion, page)
      mustache 'membre/discussion/discussion'
   end

   get %r{/membre/discussion/(\d{1,5})/reponse$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      view Views::Member::Discussion::Response.new
      mustache 'membre/discussion/response'
   end

   post %r{/membre/discussion/(\d{1,5})/reponse$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?

      message = Message.new
      message.account = current_account
      message.discussion = discussion
      message.contents = params[:message]

      if message.save
         redirect urls.discussion(discussion, discussion.total_pages, message)
      else
         view Views::Member::Discussion::Response.new(message)
         mustache 'membre/discussion/response'
      end
   end
end
