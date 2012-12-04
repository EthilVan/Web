class EthilVan::App < Sinatra::Base

   get '/membre/discussion' do
      groups = GeneralDiscussionGroup.order "priority ASC"
      view Views::Member::Discussion::Index.new groups
      mustache 'membre/discussion/index'
   end

   get %r{/membre/discussion/(\d+)$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?
      view Views::Member::Discussion::Discussion.new(discussion)
      mustache 'membre/discussion/discussion'
   end

   get '/membre/discussion/:group_name' do |group_name|
      group = GeneralDiscussionGroup.find_by_url group_name
      raise Sinatra::NotFound if group.nil?
      view Views::Member::Discussion::DiscussionGroup.new(group)
      mustache 'membre/discussion/discussion_group'
   end
end
