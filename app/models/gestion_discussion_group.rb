class GestionDiscussionGroup < ActiveRecord::Base

   ALL_READ_ID = -2
   ROLES = ['redacteur', 'modo', 'dev', 'admin']

   include DiscussionGroup

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_inclusion_of :role, in: ROLES

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def viewable_by?(account)
      account.role.inherit? EthilVan::Role.get(role.to_sym)
   end

   def followed_by?(account)
      viewable_by?(account)
   end
end
