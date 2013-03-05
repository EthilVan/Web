class Activity < ActiveRecord::Base

   module Subject

      class Filter

         def initialize(actions, block)
            @actions = actions
            @block = block
         end

         def apply(viewer, action, subject)
            return true unless @actions.include? action
            return block[viewer, subject]
         end
      end

      extend ActiveSupport::Concern

      included do
         has_many :activities, as: :subject,
               dependent: :destroy
         instance_variable_set("@_filters", {})
      end

      module ClassMethods

         attr_reader :_activities_filters

         def activities_filter(types, *actions, &block)
            filter = Filter.new(*actions, &block)
            Array(types).each { |type| add_filter(type, filter) }
         end

      private

         def add_filter(type, filter)
            (@_activities_filters[type] ||= []) << filter
         end
      end

      attr_accessor :activity_actor
   end
end
