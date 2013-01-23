class PostulationScreen < ActiveRecord::Base

   attr_accessible :url
   attr_accessible :description

   validates_format_of :url, with: /^#{URI::regexp(%w(http https))}$/
   validates_length_of :description, minimum: 20
end
