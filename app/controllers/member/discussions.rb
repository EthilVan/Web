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

   get '/membre/discussion/!creer_espace' do
      group = GeneralDiscussionGroup.new
      view Views::Member::Discussion::GroupCreate.new group
      mustache 'membre/discussion/group_create'
   end

   post '/membre/discussion/!creer_espace' do
      group = GeneralDiscussionGroup.new params[:general_discussion_group]
      redirect urls.discussion_group(group) if group.save
      view Views::Member::Discussion::GroupCreate.new group
      mustache 'membre/discussion/group_create'
   end

   group_pattern = "/membre/discussion/"
   group_pattern << "(#{GeneralDiscussionGroup::URL_PATTERN})"
   get %r{#{group_pattern}$} do |group_url|
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?
      view Views::Member::Discussion::DiscussionGroup.new(group)
      mustache 'membre/discussion/discussion_group'
   end

   get %r{#{group_pattern}/creer$} do |group_url|
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?

      discussion = Discussion.new
      discussion.group = group
      message = Message.new
      message.discussion = discussion

      view Views::Member::Discussion::Create.new(discussion, message)
      mustache 'membre/discussion/create'
   end

   post %r{#{group_pattern}/creer$} do |group_url|
      group = GeneralDiscussionGroup.find_by_url group_url
      raise Sinatra::NotFound if group.nil?

      discussion = Discussion.new
      discussion.group = group
      discussion.name = params[:name]
      message = Message.new
      message.discussion = discussion
      message.account = current_account
      message.contents = params[:message]

      if discussion.valid? and message.valid?
         discussion.save && message.save
         redirect urls.discussion(discussion)
      else
         view Views::Member::Discussion::Create.new(discussion, message)
         mustache 'membre/discussion/create'
      end
   end
end
