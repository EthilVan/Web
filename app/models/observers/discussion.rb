class DiscussionObserver < ActiveRecord::Observer

   def after_create(discussion)
      Activity.create_for(discussion.first_message.account, 'create',
            discussion)
   end

   def after_update(discussion)
      group_before = discussion.discussion_group_id_was
      group_after  = discussion.discussion_group_id
      if group_before != group_after
         Activity.create_for(discussion.activity_actor, 'moved',
               discussion, "#{group_before},#{group_after}")
      end

      archived_before = discussion.archived_was
      archived_after = discussion.archived
      if archived_before != archived_after
         Activity.create_for(discussion.activity_actor,
               archived_after ? 'archived' : 'unarchived', discussion)
      end
   end

   def after_destroy(discussion)
      Activity.create_for(discussion.activity_actor, 'deleted', nil)
   end
end

ActiveRecord::Base.observers << DiscussionObserver
