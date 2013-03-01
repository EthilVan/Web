require 'cgi'

class NewsComment < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord
   include Activity::Subject

   attr_accessible :name
   attr_accessible :email
   attr_accessible :content

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :news
   belongs_to :account

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :name,    unless: :account?
   validates_format_of   :email,   unless: :account?, with: //
   validates_length_of   :content, minimum: 10

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :content

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def account?
      not account_id.nil?
   end

   def markdown_parse(field, parsed_field)
      return super(field, parsed_field) if account?
      parsed_value = CGI.escapeHTML read_attribute field
      write_attribute(parsed_field, parsed_value)
   end
end
