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

   discussion_edit = %r{/membre/discussion/(\d{1,5})/editer$}
   protect discussion_edit, EthilVan::Role::MODO
   get discussion_edit do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      view Views::Member::Discussion::Edit.new(discussion)
      mustache 'membre/discussion/edit'
   end

   post discussion_edit do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?

      if discussion.update_attributes params[:discussion]
         redirect '/membre/discussion'
      else
         view Views::Member::Discussion::Edit.new(discussion)
         mustache 'membre/discussion/edit'
      end
   end

   discussion_delete = %r{/membre/discussion/(\d{1,5})/supprimer$}
   protect discussion_delete, EthilVan::Role::MODO
   get discussion_delete do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      discussion.destroy
      halt(200) if request.xhr?
      redirect '/membre/discussion'
   end
end
