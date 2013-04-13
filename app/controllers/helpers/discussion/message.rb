module EthilVan::App::Helpers

   module DiscussionRoutes

      extend ActiveSupport::Concern

      module ClassMethods

         def message_routes(group_type, config)
            base_url = config[:message][:url]
            url = message_base_url base_url
            views_ns = config[:message][:views]
            base_template = config[:message][:templates]

            get "#{url}/?" do |id|
               message = resource Message.find_by_id id
               message_type = message.discussion.discussion_group_type
               not_found unless message_type == group_type.name
               redirect discussion_url message
            end

            get "#{url}/editer/?" do |id|
               message = resource Message.find_by_id id
               message_type = message.discussion.discussion_group_type
               not_found unless message_type == group_type.name
               not_authorized unless message.editable_by? current_account
               message.activity_actor = current_account

               view views_ns::Edit.new message, xhr?, request.path
               mustache "#{base_template}/edit"
            end

            post "#{url}/editer/?" do |id|
               message = resource Message.find_by_id id
               message_type = message.discussion.discussion_group_type
               not_found unless message_type == group_type.name
               not_authorized unless message.editable_by? current_account
               message.activity_actor = current_account

               if message.update_attributes params[:message]
                  DiscussionView.update_for(current_account,
                        message.discussion,Time.now + 1)
                  redirect_not_xhr discussion_url message
                  view_class = EthilVan::App::Views::Partials::Message::Display
                  view view_class.new message, true
                  mustache 'message/display'
               else
                  view views_ns::Edit.new message, xhr?, request.path
                  mustache "#{base_template}/edit"
               end
            end

            get "#{url}/supprimer/?" do |id|
               message = resource Message.find_by_id id
               message_type = message.discussion.discussion_group_type
               not_found unless message_type == group_type.name
               not_found if message.first?
               not_authorized unless message.editable_by? current_account
               message.activity_actor = current_account

               following = message.following
               message.destroy
               xhr_ok_or_redirect urls::Membre::Discussion.show(message.discussion,
                     following.page, following)
            end

            return url
         end
      end
   end
end
