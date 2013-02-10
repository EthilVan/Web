class EthilVan::App < Sinatra::Base

   DISCUSSION_GROUP_BASE_URL = "/membre/discussion/"
   DISCUSSION_GROUP_BASE_URL  << "(#{GeneralDiscussionGroup::URL_PATTERN})"

   get '/membre/discussion' do
      groups = GeneralDiscussionGroup.by_priority.with_everything
      views = current_account.views_by_discussion_id
      view Views::Member::DiscussionGroup::List.new groups, views
      mustache 'membre/discussion_group/list'
   end

   get '/membre/discussion/!toutes_lues' do
      DiscussionView.mark_all_read_for(current_account)
      redirect '/membre/discussion'
   end

   protect %r{^/membre/discussion/!creer_espace$}, EthilVan::Role::MODO

   get '/membre/discussion/!creer_espace' do
      group = GeneralDiscussionGroup.new
      view Views::Member::DiscussionGroup::Create.new group
      mustache 'membre/discussion_group/create'
   end

   post '/membre/discussion/!creer_espace' do
      group = GeneralDiscussionGroup.new params[:general_discussion_group]
      redirect urls.discussion_group(group) if group.save
      view Views::Member::DiscussionGroup::Create.new group
      mustache 'membre/discussion_group/create'
   end

   get %r{#{DISCUSSION_GROUP_BASE_URL}$} do |group_url|
      group = resource GeneralDiscussionGroup.with_everything.
            find_by_url group_url
      views = current_account.views_by_discussion_id
      view Views::Member::DiscussionGroup::Show.new group, views
      mustache 'membre/discussion_group/show'
   end

   discussion_group_edit = %r{^#{DISCUSSION_GROUP_BASE_URL}/editer$}

   protect discussion_group_edit, EthilVan::Role::MODO

   get discussion_group_edit do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url
      view Views::Member::DiscussionGroup::Edit.new group
      mustache 'membre/discussion_group/edit'
   end

   post discussion_group_edit do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url
      if group.update_attributes params[:general_discussion_group]
         redirect urls.discussion_group(group)
      end
      view Views::Member::DiscussionGroup::Edit.new group
      mustache 'membre/discussion_group/edit'
   end

   discussion_group_delete = %r{^#{DISCUSSION_GROUP_BASE_URL}/supprimer$}

   protect discussion_group_delete, EthilVan::Role::MODO

   get discussion_group_delete do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url
      group.destroy
      halt(200) if request.xhr?
      redirect '/membre/discussion'
   end
end
