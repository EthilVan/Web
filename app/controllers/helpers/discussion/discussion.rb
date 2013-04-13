module EthilVan::App::Helpers

   module DiscussionRoutes

      extend ActiveSupport::Concern

      module ClassMethods

         def discussion_routes(group_type, config)
            base_url = config[:discussion][:url]
            url = discussion_base_url base_url
            group_url = discussion_group_base_url config[:group][:url]
            views_ns = config[:discussion][:views]
            message_views_ns = config[:message][:views]
            base_template = config[:discussion][:templates]
            message_base_template = config[:message][:templates]

            get %r{#{group_url}/creer/?$} do |group_url|
               group = resource group_type.find_by_url group_url

               discussion = Discussion.new
               discussion.group = group
               discussion.first_message = Message.new
               discussion.first_message.account = current_account

               view views_ns::Create.new(discussion)
               mustache 'membre/discussion/create'
            end

            post %r{#{group_url}/creer/?$} do |group_url|
               group = resource group_type.find_by_url group_url

               discussion = Discussion.new params[:discussion]
               discussion.group = group
               discussion.first_message.account = current_account

               if discussion.valid?
                  discussion.save
                  redirect urls::Membre::Discussion.show(discussion)
               else
                  view views_ns::Create.new(discussion)
                  mustache 'membre/discussion/create'
               end
            end

            get %r{#{url}/?$} do |id|
               discussion = resource Discussion.find_by_id id
               discussion_type = discussion.discussion_group_type
               not_found unless discussion_type == group_type.name
               page = discussion.page(params[:page]).includes(account:
                     [ :profil, :minecraft_stats ])
               not_found unless page.present?

               DiscussionView.update_for(current_account, discussion)

               view views_ns::Show.new(discussion, page)
               mustache "#{base_template}/show"
            end

            get %r{#{url}/repondre(?:/(\d{1,7}))?/?$} do |id, last_message|
               discussion = resource Discussion.find_by_id id
               discussion_type = discussion.discussion_group_type
               not_found unless discussion_type == group_type.name
               not_authorized if !modo? and discussion.archived?

               new_messages = []
               if inline = !!last_message && xhr?
                  new_messages = new_messages(discussion, last_message.to_i)
               end

               message = Message.new
               message.discussion = discussion
               message.account = current_account

               view message_views_ns::Create.new new_messages, message, inline
               mustache "#{message_base_template}/create"
            end

            post %r{#{url}/repondre(?:/(\d{1,7}))?/?$} do |id, last_message|
               discussion = resource Discussion.find_by_id id
               discussion_type = discussion.discussion_group_type
               not_found unless discussion_type == group_type.name
               not_authorized if !modo? and discussion.archived?

               new_messages = []
               inline = !!last_message && xhr?

               message = Message.new params[:message]
               message.discussion = discussion
               message.account = current_account

               if message.save
                  DiscussionView.update_for(current_account, discussion, Time.now + 1)
                  redirect_not_xhr urls::Membre::Discussion.show(discussion,
                        discussion.total_pages, message)
                  new_messages = new_messages(discussion, last_message.to_i)

                  view_class = EthilVan::App::Views::Partials::Discussion::Response
                  view view_class.new discussion, new_messages
                  mustache "discussion/response"
               else
                  new_messages = new_messages(discussion, last_message.to_i) if inline

                  view message_views_ns::Create.new new_messages, message, inline
                  mustache "#{base_template}/create"
               end
            end

            get %r{#{url}/editer/?$} do |id|
               discussion = resource Discussion.find_by_id id
               discussion_type = discussion.discussion_group_type
               not_found unless discussion_type == group_type.name

               discussion.activity_actor = current_account

               view views_ns::Edit.new(discussion)
               mustache "#{base_template}/edit"
            end

            post %r{#{url}/editer/?$} do |id|
               discussion = resource Discussion.find_by_id id
               discussion_type = discussion.discussion_group_type
               not_found unless discussion_type == group_type.name

               discussion.activity_actor = current_account

               if discussion.update_attributes params[:discussion]
                  redirect base_url
               else
                  view views_ns::Edit.new(discussion)
                  mustache "#{base_template}/edit"
               end
            end

            get %r{#{url}/supprimer/?$} do |id|
               discussion = resource Discussion.find_by_id id
               discussion_type = discussion.discussion_group_type
               not_found unless discussion_type == group_type.name

               discussion.activity_actor = current_account
               discussion.destroy

               xhr_ok_or_redirect base_url
            end

            return url
         end
      end
   end
end
