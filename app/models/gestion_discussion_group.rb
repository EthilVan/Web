class GestionDiscussionGroup < ActiveRecord::Base

   ROLES = [:redacteur, :modo, :dev, :admin]

   include DiscussionGroup

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_inclusion_of :role, in: ROLES

end
