module EthilVan::Mustache

   class Form::Select < Form::Field

      class Option

         attr_reader :name, :value

         def initialize(current, name, value = name)
            @name = name
            @value = value
            @selected = current == name.to_s
         end

         def selected
            @selected ? ' selected' : ''
         end
      end

      attr_reader :among
      alias options among

      def initialize(form, name, value = '', among = {}, attributes = {})
         super(form, name, attributes)
         @value = value
         @among = among.map { |args| Option.new(value, *args) }
      end
   end
end
