class Profil < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account, inverse_of: :profil

   # ==========================================================================
   # * Validations
   # ==========================================================================
   class BirthDateValidator < ActiveModel::Validator

      def validate(record)
         return if record.birthdate_formatted.blank?
         if record.birthdate_formatted =~ /^(\d{2})\/(\d{2})\/(\d{4})$/
            return if Date.valid_civil?($3.to_i, $2.to_i, $1.to_i)
         end
         record.errors.add(:birthdate_formatted, :invalid)
      end
   end

   validates_inclusion_of :sexe, in: EthilVan::Data::Sexe.map(&:second)
   validates_with BirthDateValidator

   validates_length_of :minecraft_since, minimum: 20

   regexp = /\A[A-Za-z][\w\-_]{1,}\Z/
   validates_format_of :youtube,  with: regexp, allow_blank: true
   validates_format_of :twitter,  with: regexp, allow_blank: true
   validates_format_of :steam_id, with: regexp, allow_blank: true

   validates_format_of :website,
         with: /^#{URI::regexp(%w(http https))}$/,
         allow_blank: true

   validates_format_of :custom_cadre_url,
         with: /^#{URI::regexp(%w(http https))}$/,
         allow_blank: true

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :signature
   before_save :parse_birthdate, if: :new_birthdate?

   # ==========================================================================
   # * Methods
   # ==========================================================================
   attr_writer :birthdate_formatted

   def birthdate_formatted
      if @birthdate_formatted.present? or birthdate.nil?
         @birthdate_formatted
      else
         birthdate.strftime EthilVan::Data::DATE_FORMAT
      end
   end

   def age
     Time.at(Time.now - birthdate).year - 1970
   end

   def head_url(scale = nil)
      EthilVan::Urls.skin_head(account, scale)
   end

   def avatar_url
      return head_url(15) if avatar.nil?
      return avatar
   end

   def cadre_url
     if custom_cadre_url.present?
         custom_cadre_url
     else
         '/images/membre/profil/cadre.png'
     end
   end

private

   def new_birthdate?
      @birthdate_formatted.present?
   end

   def parse_birthdate
      a = birthdate_formatted.split("/").map { |s| s.to_i }
      self.birthdate = Date.civil(*a.reverse)
   end
end
