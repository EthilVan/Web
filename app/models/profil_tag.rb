class ProfilTag < ActiveRecord::Base

   attr_accessible :contents

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :tagger, class_name: 'Account'
   belongs_to :tagged, class_name: 'Account'

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_length_of :contents, within: 2..120
end
