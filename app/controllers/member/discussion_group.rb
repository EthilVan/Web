class EthilVan::App < Sinatra::Base

   DISCUSSION_GROUP_BASE_URL = "/membre/discussion/"
   DISCUSSION_GROUP_BASE_URL  << "(#{GeneralDiscussionGroup::URL_PATTERN})"

   get '/membre/discussion' do
      groups = GeneralDiscussionGroup.by_priority
      view Views::Member::DiscussionGroup::Index.new groups
      mustache 'membre/discussion_group/index'
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
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?
      view Views::Member::DiscussionGroup::Show.new(group)
      mustache 'membre/discussion_group/show'
   end

   discussion_group_edit = %r{^#{DISCUSSION_GROUP_BASE_URL}/editer$}

   protect discussion_group_edit, EthilVan::Role::MODO

   get discussion_group_edit do |group_url|
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?
      view Views::Member::DiscussionGroup::Edit.new group
      mustache 'membre/discussion_group/edit'
   end

   post discussion_group_edit do |group_url|
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?
      if group.update_attributes params[:general_discussion_group]
         redirect urls.discussion_group(group)
      end
      view Views::Member::DiscussionGroup::Edit.new group
      mustache 'membre/discussion_group/edit'
   end
end
