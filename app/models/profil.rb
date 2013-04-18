class Profil < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord
   include Activity::Subject

   attr_accessible :minecraft_since
   attr_accessible :favorite_block
   attr_accessible :favorite_item
   attr_accessible :skill
   attr_accessible :desc_rp
   attr_accessible :birthdate_formatted
   attr_accessible :sexe
   attr_accessible :localisation
   attr_accessible :availability
   attr_accessible :website
   attr_accessible :twitter
   attr_accessible :youtube
   attr_accessible :description
   attr_accessible :avatar
   attr_accessible :signature
   attr_accessible :steam_id
   attr_accessible :custom_cadre_url
   attr_accessible :show_email
   attr_accessible :categories

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

   validates_inclusion_of :sexe, in: EthilVan::Data::Sexe.keys
   validates_with BirthDateValidator

   validates_length_of :minecraft_since, minimum: 20

   regexp = /\A[A-Za-z][\w\-_]{1,}\Z/
   validates_format_of :youtube,  with: regexp, allow_blank: true
   validates_format_of :twitter,  with: regexp, allow_blank: true
   validates_format_of :steam_id, with: regexp, allow_blank: true

   url_regexp = /^#{URI::regexp(%w(http https))}$/
   validates_format_of :website,          with: url_regexp, allow_blank: true
   validates_format_of :avatar,           with: url_regexp, allow_blank: true
   validates_format_of :custom_cadre_url, with: url_regexp, allow_blank: true

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :signature
   before_save :parse_birthdate, if: :new_birthdate?
   before_save :update_categories_int, if: :categories_updated?

   # ==========================================================================
   # * Methods
   # ==========================================================================
   attr_writer :birthdate_formatted

   def birthdate_formatted
      if @birthdate_formatted.present? or birthdate.nil?
         @birthdate_formatted
      else
         birthdate.strftime '%d/%m/%Y'
      end
   end

   def age
      Time.at(Time.now - birthdate).year - 1970
   end

   def head_url(scale = nil)
      EthilVan::Url::Member::Skin.head(account, scale)
   end

   def avatar_url
      return EthilVan::Url::Member::Skin.avatar(account) if avatar.blank?
      avatar
   end

   DEFAULT_CADRE = EthilVan::Static::Helpers.asset(
         'images/membre/profil/cadre.png')
   def cadre_url
      return DEFAULT_CADRE if custom_cadre_url.blank?
      custom_cadre_url
   end

   def categories
      @categories || NewsCategories.new(categories_int)
   end

   def categories=(names)
      @categories = NewsCategories.new_from_names(*names)
   end

private

   def new_birthdate?
      @birthdate_formatted.present?
   end

   def parse_birthdate
      a = birthdate_formatted.split("/").map { |s| s.to_i }
      self.birthdate = Date.civil(*a.reverse)
   end

   def categories_updated?
      not @categories.nil?
   end

   def update_categories_int
      write_attribute :categories_int, @categories.value
   end
end
