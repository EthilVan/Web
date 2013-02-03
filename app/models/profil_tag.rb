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
   validate :tagger_is_not_tagged

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def tagger_is_not_tagged
      errors.add(:tagger, :invalid) if tagger_id == tagged_id
   end
end
