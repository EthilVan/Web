module EthilVan::App::Helpers

   module DiscussionRoutes

      extend ActiveSupport::Concern

      module ClassMethods

         def discussion_routes(group_type, config)
            discussion_urls = config[:urls]
            url = discussion_base_url discussion_urls.discussion.root
            group_url = discussion_group_base_url discussion_urls.group.root

            views_ns = config[:discussion][:views]
            message_views_ns = config[:message][:views]
            base_template = config[:discussion][:templates]
            message_base_template = config[:message][:templates]

            get %r{#{group_url}/creer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               not_authorized unless group.viewable_by? current_account

               discussion = Discussion.new
               discussion.group = group
               discussion.first_message = Message.new
               discussion.first_message.account = current_account

               view views_ns::Create.new(discussion_urls, discussion)
               mustache 'membre/discussion/create'
            end

            post %r{#{group_url}/creer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               not_authorized unless group.viewable_by? current_account

               discussion = Discussion.new params[:discussion]
               discussion.group = group
               discussion.first_message.account = current_account

               if discussion.valid?
                  discussion.save
                  redirect discussion_urls.discussion.show(discussion)
               else
                  view views_ns::Create.new(discussion_urls, discussion)
                  mustache 'membre/discussion/create'
               end
            end

            get %r{#{url}/?$} do |id|
               discussion = resource Discussion.find_by_id id
               group = discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account

               page = discussion.page(params[:page]).includes(account:
                     [ :profil, :minecraft_stats ])
               not_found unless page.present?

               update_discussion_view(current_account, discussion)

               view views_ns::Show.new(discussion_urls, discussion, page)
               mustache "#{base_template}/show"
            end

            get %r{#{url}/repondre(?:/(\d{1,7}))?/?$} do |id, last_message|
               discussion = resource Discussion.find_by_id id
               group = discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account
               not_authorized if !modo? and discussion.archived?

               new_messages = []
               if inline = !!last_message && xhr?
                  new_messages = new_messages(discussion, last_message.to_i)
               end

               message = Message.new
               message.discussion = discussion
               message.account = current_account

               view message_views_ns::Create.new discussion_urls, new_messages, message, inline
               mustache "#{message_base_template}/create"
            end

            post %r{#{url}/repondre(?:/(\d{1,7}))?/?$} do |id, last_message|
               discussion = resource Discussion.find_by_id id
               group = discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account
               not_authorized if !modo? and discussion.archived?

               new_messages = []
               inline = !!last_message && xhr?

               message = Message.new params[:message]
               message.discussion = discussion
               message.account = current_account

               if message.save
                  update_discussion_view(current_account, discussion, Time.now + 1)
                  redirect_not_xhr discussion_urls.discussion.show(discussion,
                        discussion.total_pages, message)
                  new_messages = new_messages(discussion, last_message.to_i)

                  view_class = EthilVan::App::Views::Partials::Discussion::Response
                  view view_class.new discussion_urls, discussion, new_messages
                  mustache "discussion/response"
               else
                  new_messages = new_messages(discussion, last_message.to_i) if inline

                  view message_views_ns::Create.new discussion_urls, new_messages, message, inline
                  mustache "#{base_template}/create"
               end
            end

            get %r{#{url}/editer/?$} do |id|
               discussion = resource Discussion.find_by_id id
               group = discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account

               discussion.activity_actor = current_account

               view views_ns::Edit.new(discussion_urls, discussion)
               mustache "#{base_template}/edit"
            end

            post %r{#{url}/editer/?$} do |id|
               discussion = resource Discussion.find_by_id id
               group = discussion.group
               not_found unless group.is_a? group_type
               not_authorized unless group.viewable_by? current_account

               discussion.activity_actor = current_account

               if discussion.update_attributes params[:discussion]
                  redirect discussion_urls.discussion.root
               else
                  view views_ns::Edit.new(discussion_urls, discussion)
                  mustache "#{base_template}/edit"
               end
            end

            get %r{#{url}/supprimer/?$} do |id|
               discussion = resource Discussion.find_by_id id
               discussion_type = discussion.discussion_group_type
               not_found unless discussion_type == group_type.name

               discussion.activity_actor = current_account
               discussion.destroy

               xhr_ok_or_redirect discussion_urls.discussion.root
            end

            return url
         end
      end
   end
end
