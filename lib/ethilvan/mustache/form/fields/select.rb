class EthilVan::Mustache::Form

   class Select < Field

      class Option

         attr_reader :name, :value

         def initialize(current, name, value = name)
            @name = name
            @value = value
            @selected = current.to_s == name.to_s
         end

         def selected
            @selected ? ' selected' : ''
         end
      end

      attr_reader :among
      alias options among

      def initialize(fieldset, name, value, validations, errors, attributes)
         super(fieldset, name, validations, errors, attributes)
         @among = (attributes[:among] || []).map do |args|
            Option.new(value, *args)
         end
      end
   end
end
