require 'sinatra/base'

module EthilVan::SinatraHelpers

   def self.registered(app)
      app.extend ClassMethods
      app.helpers InstanceMethods
   end

   module ClassMethods

      [
         'get', 'put', 'post', 'delete', 'head', 'options', 'patch'
      ].each do |method|
         self.class_eval(<<-EOF)
            def xhr_#{method}(path, opts={}, &block)
               opts[:xhr_only] = true
               #{method}(path, opts, &block)
            end
         EOF
      end

      def xhr_only(value)
         condition { xhr? == value }
      end
   end

   module InstanceMethods

      def not_found
         halt(404)
      end

      def no_content
         halt(204)
      end

      def resource(res)
         not_found if res.nil?
         return res
      end

      def resources(res)
         return res unless res.empty?
         no_content if xhr?
         not_found
      end

      def xhr?
         @__xhr ||= request.xhr?
      end

      def redirect_not_xhr(url)
         redirect url unless xhr?
      end

      def xhr_ok_or_redirect(url)
         halt(200) if xhr?
         redirect url
      end
   end
end
