class CreateNewsComments < ActiveRecord::Migration

	def self.up
      create_table :news_comments do |t|
         t.integer    :news_id

         t.integer    :account_id
         t.string     :name
         t.string     :email

         t.text       :content
         t.text       :parsed_content

         t.timestamp  :created_at
      end
   end

   def self.down
      drop_table :news_comments
   end
end
