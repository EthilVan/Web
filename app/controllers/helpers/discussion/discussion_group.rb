module EthilVan::App::Helpers

   module DiscussionRoutes

      extend ActiveSupport::Concern

      module ClassMethods

         def discussion_group_routes(group_type, config)
            base_url = config[:group][:url]
            url = discussion_group_base_url base_url
            views_ns = config[:group][:views]
            base_template = config[:group][:templates]

            get "#{base_url}/?" do
               groups = group_type.by_priority.with_everything
               views = current_account.views_by_discussion_id
               view views_ns::List.new groups, views
               mustache "#{base_template}/list"
            end

            get "#{base_url}/!toutes_lues/?" do
               DiscussionView.mark_all_read_for(current_account)
               redirect base_url
            end

            get "#{base_url}/!creer_espace/?" do
               group = group_type.new
               view views_ns::Create.new group
               mustache "#{base_template}/create"
            end

            post "#{base_url}/!creer_espace/?" do
               group = group_type.new params[group_type.model_name.param_key]
               redirect urls.discussion_group(group) if group.save
               view views_ns::Create.new group
               mustache "#{base_template}/create"
            end

            get %r{#{url}/?$} do |group_url|
               group = resource group_type.with_everything.
                     find_by_url group_url
               views = current_account.views_by_discussion_id
               view views_ns::Show.new group, views
               mustache "#{base_template}/show"
            end

            get %r{#{url}/editer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               view views_ns::Edit.new group
               mustache "#{base_template}/edit"
            end

            post %r{#{url}/editer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               if group.update_attributes params[group_type.model_name.param_key]
                  redirect urls.discussion_group(group)
               end
               view views_ns::Edit.new group
               mustache "#{base_template}/edit"
            end

            get %r{#{url}/supprimer/?$} do |group_url|
               group = resource group_type.find_by_url group_url
               group.destroy
               xhr_ok_or_redirect base_url
            end

            return url
         end
      end
   end
end
