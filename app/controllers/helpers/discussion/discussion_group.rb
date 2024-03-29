module EthilVan::App::Helpers

   module DiscussionRoutes

      extend ActiveSupport::Concern

      module ClassMethods

         def discussion_group_routes(group_type, config)
            discussion_urls = config[:urls]
            url = discussion_group_base_url discussion_urls.group.root

            views_ns = config[:group][:views]
            base_template = config[:group][:templates]

            get "#{discussion_urls.group.root}/?" do
               groups = group_type.by_priority.with_everything
               groups = groups.select { |group| group.viewable_by? current_account }

               views = DiscussionViews.new(group_type, current_account)
               view views_ns::List.new discussion_urls, groups, views
               mustache "#{base_template}/list"
            end

            get "#{discussion_urls.group.root}/!toutes_lues/?" do
               DiscussionView.mark_all_read_for(group_type, current_account)
               redirect discussion_urls.group.root
            end

            get "#{discussion_urls.group.root}/!creer_espace/?" do
               group = group_type.new
               view views_ns::Create.new discussion_urls, group
               mustache "#{base_template}/create"
            end

            post "#{discussion_urls.group.root}/!creer_espace/?" do
               group = group_type.new params[group_type.model_name.param_key]
               redirect discussion_urls.group.show(group) if group.save
               view views_ns::Create.new discussion_urls, group
               mustache "#{base_template}/create"
            end

            get %r{#{url}/?$} do |group_url|
               group = resource group_type.with_everything.
                     find_by_url group_url
               not_authorized unless group.viewable_by? current_account

               views = DiscussionViews.new(group_type, current_account)
               view views_ns::Show.new discussion_urls, group, views
               mustache "#{base_template}/show"
            end

            get %r{#{url}/editer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               not_authorized unless group.viewable_by? current_account

               view views_ns::Edit.new discussion_urls, group
               mustache "#{base_template}/edit"
            end

            post %r{#{url}/editer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               not_authorized unless group.viewable_by? current_account

               if group.update_attributes params[group_type.model_name.param_key]
                  redirect discussion_urls.group.show(group)
               end
               view views_ns::Edit.new discussion_urls, group
               mustache "#{base_template}/edit"
            end

            get %r{#{url}/supprimer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               not_authorized unless group.viewable_by? current_account

               group.destroy
               xhr_ok_or_redirect discussion_urls.group.root
            end

            return url
         end
      end
   end
end
