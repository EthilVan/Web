module EthilVan

   module Data

      module Contact; end

      yaml = EthilVan.load_data('misc', 'data')

      Sexe     = yaml["sexe"]
      Mumble   = yaml["mumble"]

      Contact::Categories = yaml["contact"]["categories"]
      Contact::Receiver   = yaml["contact"]["receiver"]
   end
end
