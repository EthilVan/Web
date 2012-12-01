if RUBY_PLATFORM == 'java'

   class Time

      alias ev_strftime strftime unless method_defined? :ev_strftime
      def strftime(*args)
         ev_strftime(*args).encode('UTF-8')
      end
   end
end
