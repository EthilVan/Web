require 'action_view'

module EthilVan::Mustache

   class Partial < ::Mustache

      include ActionView::Helpers::DateHelper

      attr_accessor :app
   end
end
