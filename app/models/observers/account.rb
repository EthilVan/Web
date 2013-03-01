class AccountObserver < ActiveRecord::Observer

   def after_create(account)
      Activity.create_for(nil, 'create', account)
   end

   def after_update(account)
      role_before = account.role_was
      role_after = account.role
      if role_before != role_after
         inherit = role_before.inherit?(role_after)
         action = inherit ? 'destituted' : 'promoted'
         Activity.create_for(nil, action, account,
               "#{role_before.id},#{role_after.id}")
      end
   end
end

ActiveRecord::Base.observers << AccountObserver
