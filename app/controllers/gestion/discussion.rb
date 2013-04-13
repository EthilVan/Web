class EthilVan::App < Sinatra::Base

   discussion_routes_config = {
      urls: DiscussionUrls.new(
         EthilVan::Url::Gestion::DiscussionGroup,
         EthilVan::Url::Gestion::Discussion,
         EthilVan::Url::Gestion::Message
      ),
      group: {
         views:     Views::Gestion::DiscussionGroup,
         templates: 'gestion/discussion_group',
      },
      discussion: {
         views:     Views::Gestion::Discussion,
         templates: 'gestion/discussion',
      },
      message: {
         views:     Views::Gestion::Message,
         templates: 'gestion/message',
      },
   }

   discussion_group_routes GestionDiscussionGroup, discussion_routes_config
   discussion_routes       GestionDiscussionGroup, discussion_routes_config
   message_routes          GestionDiscussionGroup, discussion_routes_config
end
