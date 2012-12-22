class ProfilTag < ActiveRecord::Base

   belongs_to :tagger, :class_name => 'Account'
   belongs_to :tagged, :class_name => 'Account'
end
