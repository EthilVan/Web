class NewsCategories

   def self.c_enum(*names)
      i, value = -1, lambda { i += 1; 1 << i }
      names.each_with_object({}) { |name, object| object[name] = value[] }
   end

   @@categories = c_enum(
      :misc,
      :projects,
      :events,
      :dev,
      :server,
      :website,
      :launcher,
      :update,
      :management
   )

   attr_reader :value

   def self.all
      new_from_names(*@@categories.keys)
   end

   def self.names
      @@categories.keys
   end

   def self.new_from_names(*names)
      instance = new
      names.each { |name| instance << name }
      instance
   end

   def initialize(value = 0)
      @value = value
   end

   def <<(name)
      return unless enum_name? name
      @value |= enum_value(name)
   end

   def include?(name)
      return false unless enum_name? name
      return value_match? enum_value name
   end

   def match?(arg)
      if arg.is_a? NewsCategories
         arg_value = arg.value
      else
         return false unless enum_name? arg
         arg_value = enum_value(arg)
      end
      (value == 0 and arg_value == 0) or value_match?(arg_value)
   end
   alias =~ match?

   def match_any?(*names)
      match? NewsCategories.new_from_names(*names)
   end

   def size
      enum_each.count { |name, val| value_match? val }
   end

   def to_a
      enum_each.select { |name, val| value_match? val }.map &:first
   end

   def to_h
      enum_each.each_with_object({}) do |entry, hash|
         hash[entry.first] = value_match? entry[1]
      end
   end

private

   def value_match?(other)
      value & other > 0
   end

   def enum_name?(name)
      @@categories.key? name.to_s.to_sym
   end

   def enum_value(name)
      @@categories[name.to_s.to_sym]
   end

   def enum_each(&block)
      @@categories.each(&block)
   end
end
