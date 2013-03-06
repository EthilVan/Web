class PostulationVote < ActiveRecord::Base

   include Activity::Subject

   Roles = ['admin', 'dev', 'modo']

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account
   belongs_to :postulation

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_length_of :message, minimum: 20, if: :refusal?

   # ==========================================================================
   # * Activity
   # ==========================================================================
   activities_includes :postulation

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def self.total_needed
      Account.where(role_id: Roles, vote_needed: true).size
   end

   def self.for?(account, postulation)
      where(account_id: account.id, postulation_id: postulation.id).exists?
   end

   def self.for(account, postulation)
      where(account_id: account.id, postulation_id: postulation.id).first
   end

   def agreement?
      agreement
   end

   def agreement_needed?
      agreement? and account.vote_needed
   end

   def refusal?
      not agreement?
   end
end
