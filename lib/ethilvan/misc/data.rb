module EthilVan

   module Data

      module News; end
      module Contact; end

      yaml = EthilVan.load_data('misc', 'data')

      Sexe     = yaml["sexe"]
      Mumble   = yaml["mumble"]

      News::Categories = yaml["news"]["categories"]

      Contact::Categories = yaml["contact"]["categories"]
      Contact::Receiver   = yaml["contact"]["receiver"]
   end
end
