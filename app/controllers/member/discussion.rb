class EthilVan::App < Sinatra::Base

   discussion_routes_config = {
      group: {
         url:       '/membre/discussion',
         views:     Views::Member::DiscussionGroup,
         templates: 'membre/discussion_group',
      },
      discussion: {
         url:       '/membre/discussion',
         views:     Views::Member::Discussion,
         templates: 'membre/discussion',
      },
      message: {
         url:       '/membre/message',
         views:     Views::Member::Message,
         templates: 'membre/message',
      },
   }

   group_url      = discussion_group_routes GeneralDiscussionGroup,
         discussion_routes_config
   discussion_url = discussion_routes       GeneralDiscussionGroup,
         discussion_routes_config
   message_url    = message_routes          GeneralDiscussionGroup,
         discussion_routes_config

   get %r{#{group_url}/suivre/?$} do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url
      DiscussionGroupSubscription.create_for(current_account, group)
      redirect '/membre/discussion'
   end

   get %r{#{group_url}/neplussuivre/?$} do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url
      DiscussionGroupSubscription.destroy_for(current_account, group)
      redirect '/membre/discussion'
   end

   get %r{#{group_url}/toutsuivre/?$} do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url
      group.discussions.each do |discussion|
         DiscussionSubscription.create_for(current_account, discussion)
      end
      redirect '/membre/discussion'
   end

   get %r{#{group_url}/neplusriensuivre/?$} do |group_url|
      group = resource GeneralDiscussionGroup.find_by_url group_url
      group.discussions.each do |discussion|
         DiscussionSubscription.destroy_for(current_account, discussion)
      end
      redirect '/membre/discussion'
   end

   get %r{#{discussion_url}/suivre/?$} do |id|
      discussion = resource Discussion.find_by_id id
      DiscussionSubscription.create_for(current_account, discussion)
      redirect '/membre/discussion'
   end

   get %r{#{discussion_url}/neplussuivre/?$} do |id|
      discussion = resource Discussion.find_by_id id
      DiscussionSubscription.destroy_for(current_account, discussion)
      redirect '/membre/discussion'
   end
end
