module EthilVan::Mustache

   module Form

      class Select < Partial

         def initialize(selected)
            @selected = selected.map { |s| :"#{s}?" }
         end

         def respond_to?(name)
            return false if name == :has_key?
            super(name) || name[-1] == ??
         end

         def method_missing(name, *args)
            if name[-1] == ??
               @selected.include?(name) ? 'selected="selected"' : ''
            else
               super(name, *args)
            end
         end
      end

      def field(value)
         return '' if value.nil?
         return "value=\"#{escapeHTML value}\" "
      end

      def checkbox(value)
         return 'value="1" ' unless value
         return "value=\"1\" checked=\"checked\" "
      end

      def select(*selected, among)
         return {} if selected.nil?
         selected.flatten!
         return {} if selected.all? &:nil?
         Select.new selected
      end
   end
end
