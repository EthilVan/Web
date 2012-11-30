if RUBY_PLATFORM == 'java'

   class Time

      alias ethilvan_strftime strftime if !method_defined? :ethilvan_strftime
      def strftime(*args)
         ethilvan_strftime(*args).encode('UTF-8')
      end
   end
end
