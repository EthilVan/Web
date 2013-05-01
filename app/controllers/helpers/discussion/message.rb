module EthilVan::App::Helpers

   module DiscussionRoutes

      extend ActiveSupport::Concern

      module ClassMethods

         def message_routes(group_type, config)
            discussion_urls = config[:urls]
            url = message_base_url discussion_urls.message.root

            views_ns = config[:message][:views]
            base_template = config[:message][:templates]

            get "#{url}/?" do |id|
               message = resource Message.find_by_id id
               group = message.discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account

               redirect discussion_url(discussion_urls, message)
            end

            get "#{url}/editer/?" do |id|
               message = resource Message.find_by_id id
               group = message.discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account
               not_authorized unless message.editable_by? current_account
               message.activity_actor = current_account

               view views_ns::Edit.new discussion_urls, message, xhr?, request.path
               mustache "#{base_template}/edit"
            end

            post "#{url}/editer/?" do |id|
               message = resource Message.find_by_id id
               group = message.discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account
               not_authorized unless message.editable_by? current_account
               message.activity_actor = current_account

               if message.update_attributes params[:message]
                  update_discussion_view(current_account, message.discussion,Time.now + 1)
                  redirect_not_xhr discussion_url discussion_urls, message
                  view_class = EthilVan::App::Views::Partials::Message::Display
                  view view_class.new discussion_urls, message, true
                  mustache 'message/display'
               else
                  view views_ns::Edit.new discussion_urls, message, xhr?, request.path
                  mustache "#{base_template}/edit"
               end
            end

            get "#{url}/supprimer/?" do |id|
               message = resource Message.find_by_id id
               group = message.discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account
               not_found if message.first?
               not_authorized unless message.editable_by? current_account
               message.activity_actor = current_account

               following = message.following
               message.destroy
               xhr_ok_or_redirect discussion_urls.discussion.show(message.discussion,
                     following.page, following)
            end

            return url
         end
      end
   end
end
