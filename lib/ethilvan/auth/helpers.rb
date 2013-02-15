module EthilVan::AuthHelpers

   def current?(account)
      current_account.id == account.id
   end

   def current_role
      @current_role ||= current_account.role
   end

   def has_role?(role)
      current_role.inherit?(role)
   end

   def has_super_role?(role)
      current_role.strict_inherit?(role)
   end

   def modo?
      has_role?(EthilVan::Role::MODO)
   end

   def redacteur?
      has_role?(EthilVan::Role::REDACTEUR)
   end
end
