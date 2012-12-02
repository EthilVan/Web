require_relative '../helpers'

class MiniTest::Unit::TestCase

   def assert_valid(model, *fields)
      model.valid?
      errors = validate_ar_model(model, fields).reject { |n, v| v.nil? }
      self._assertions += 1
      unless errors.empty?
         raise MiniTest::Assertion, <<-END
  Expected <#{ model.class }> to be valid with <#{ mu_ary_pp(fields) }>,
  Got errors <#{ mu_hash_pp(errors) }>.
         END
      end
   end

   def assert_valid_with(model, fields)
      old_fields = {}
      fields.each do |name, value|
         old_fields[name] = model.send name
         model.send("#{name}=", value)
      end
      errors = validate_ar_model(model, fields.keys).reject { |n, v| v.nil? }
      self._assertions += 1
      old_fields.each do |name, old_value|
         model.send("#{name}=", old_value)
      end
      unless errors.empty?
         raise MiniTest::Assertion, <<-END
  Expected <#{ model.class }> to be valid with <#{ mu_hash_pp(fields) }>,
  Got errors <#{ mu_hash_pp(errors) }>.
         END
      end
   end

   def refute_valid(model, *fields)
      model.valid?
      errors = validate_ar_model(model, fields).select { |n, v| v.nil? }
      self._assertions += 1

      unless errors.empty?
         raise MiniTest::Assertion, <<-END
  Expected <#{ model.class }> to not be valid for <#{ mu_ary_pp(fields) }>,
  Got valid <#{ mu_ary_pp(errors.keys) }>
         END
      end
   end

   def refute_valid_with(model, fields)
      old_fields = {}
      fields.each do |name, value|
         old_fields[name] = model.send name
         model.send("#{name}=", value)
      end
      errors = validate_ar_model(model, fields.keys).select { |n, v| v.nil? }
      self._assertions += 1
      old_fields.each do |name, old_value|
         model.send("#{name}=", old_value)
      end
      unless errors.empty?
         raise MiniTest::Assertion, <<-END
  Expected <#{ model.class }> to not be valid with <#{ mu_hash_pp(fields) }>,
  Got valid <#{ mu_ary_pp(errors.keys) }>
         END
      end
   end

private

   def validate_ar_model(model, fields)
      model.valid?
      model.errors.to_hash.extract!(*fields)
   end

   def mu_ary_pp(ary)
      ary * ','
   end

   def mu_hash_pp(hash)
      hash.map { |n, v| "#{n}: #{mu_pp(v)}" } * ', '
   end
end
