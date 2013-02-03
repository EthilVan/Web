class EthilVan::App < Sinatra::Base

   get %r{#{DISCUSSION_GROUP_BASE_URL}/creer$} do |group_url|
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?

      discussion = Discussion.new
      discussion.group = group
      discussion.first_message = Message.new

      view Views::Member::Discussion::Create.new(discussion)
      mustache 'membre/discussion/create'
   end

   post %r{#{DISCUSSION_GROUP_BASE_URL}/creer$} do |group_url|
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?

      discussion = Discussion.new params[:discussion]
      discussion.group = group
      discussion.first_message.account = current_account

      if discussion.valid?
         discussion.save
         redirect urls.discussion(discussion)
      else
         view Views::Member::Discussion::Create.new(discussion)
         mustache 'membre/discussion/create'
      end
   end

   get %r{/membre/discussion/(\d{1,5})$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      page = discussion.page(params[:page]).
            includes(account: [ :profil, :minecraft_stats ])
      raise Sinatra::NotFound unless page.present?
      DiscussionView.update_for(current_account, discussion)
      view Views::Member::Discussion::Show.new(discussion, page)
      mustache 'membre/discussion/show'
   end

   get %r{/membre/discussion/(\d{1,5})/repondre$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      view Views::Member::Discussion::Respond.new
      mustache 'membre/discussion/respond'
   end

   post %r{/membre/discussion/(\d{1,5})/repondre$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?

      message = Message.new
      message.account = current_account
      message.discussion = discussion
      message.contents = params[:message]

      if message.save
         redirect urls.discussion(discussion, discussion.total_pages, message)
      else
         view Views::Member::Discussion::Respond.new(message)
         mustache 'membre/discussion/respond'
      end
   end

   discussion_delete = %r{/membre/discussion/(\d{1,5})/supprimer$}

   protect discussion_delete, EthilVan::Role::MODO

   get discussion_delete do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      discussion.destroy
      redirect '/membre/discussion'
   end
end
