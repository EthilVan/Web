class Postulation < ActiveRecord::Base

   belongs_to :account, inverse_of: :postulation
   has_many :screens, :class_name => "PostulationScreen"
end
