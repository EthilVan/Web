require_relative '../helpers'

class MarkdownTest < MiniTest::Spec

   include EthilVan::Markdown::Helpers

   def test_mentions
      markdown('@user'     ).must_match /<a /
      markdown('@notanuser').wont_match /<a /
   end

   def test_mention_with_underscore
      DatabaseCleaner.start
      Account.where(name: 'user').first.
            update_attribute(:name, 'username_with_underscores')

      markdown('@username_with_underscores').must_match /<a /
      markdown('@username_with_underscoret').wont_match /<a /

      DatabaseCleaner.clean
   end

   def test_oembed
      parsed = markdown <<-MD
![Check this out](http://www.youtube.com/watch?v=oHg5SJYRHA0)
MD
      parsed.must_match /<iframe /
   end
end
