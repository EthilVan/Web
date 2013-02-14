class EthilVan::App < Sinatra::Base

   get %r{#{DISCUSSION_GROUP_BASE_URL}/creer$} do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url

      discussion = Discussion.new
      discussion.group = group
      discussion.first_message = Message.new
      discussion.first_message.account = current_account

      view Views::Member::Discussion::Create.new(discussion)
      mustache 'membre/discussion/create'
   end

   post %r{#{DISCUSSION_GROUP_BASE_URL}/creer$} do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url

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
      discussion = resource Discussion.find_by_id id
      page = discussion.page(params[:page]).includes(account:
            [ :profil, :minecraft_stats ])
      not_found unless page.present?

      DiscussionView.update_for(current_account, discussion)

      view Views::Member::Discussion::Show.new(discussion, page)
      mustache 'membre/discussion/show'
   end

   discussion_edit = %r{/membre/discussion/(\d{1,5})/editer$}
   protect discussion_edit, EthilVan::Role::MODO
   get discussion_edit do |id|
      discussion = resource Discussion.find_by_id id
      view Views::Member::Discussion::Edit.new(discussion)
      mustache 'membre/discussion/edit'
   end

   post discussion_edit do |id|
      discussion = resource Discussion.find_by_id id

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
      discussion = resource Discussion.find_by_id id
      discussion.destroy
      xhr_ok_or_redirect '/membre/discussion'
   end
end
