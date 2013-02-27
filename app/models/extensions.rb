module ActiveModel

   module Validations

      class AcceptanceValidator < EachValidator

         def initialize(options)
            super({ allow_nil: true, accept: "true" }.merge!(options))
         end
      end
   end
end
