class Activity < ActiveRecord::Base

   module Subject

      def self.reload!
         @list.each do |subject|
            instance_variable_set("@_activities_includes", [])
            instance_variable_set("@_activities_filters",  {})
         end
         @list = []
      end

      class Filter

         def initialize(actions, block)
            @actions = actions.map &:to_s
            @block = block
         end

         def apply(viewer, activity)
            return true unless @actions.include? activity.action
            return @block[viewer, activity.subject, activity]
         end
      end

      extend ActiveSupport::Concern

      EthilVan.development? do
         class << Subject; attr_reader :list; end
         @list = []
      end

      included do
         EthilVan.development? { Subject.list << self }
         has_many :activities, as: :subject,
               dependent: :destroy
         instance_variable_set("@_activities_includes", [])
         instance_variable_set("@_activities_filters",  {})
      end

      module ClassMethods

         attr_reader :_activities_includes
         attr_reader :_activities_filters

         def activities_includes(*includes)
            @_activities_includes << includes
         end

         def activities_filter(types, *actions, &block)
            filter = Filter.new(actions, block)
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
