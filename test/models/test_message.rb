require_relative 'helpers'

class MessageTest < MiniTest::Spec

   def setup
      @message = Message.new
   end

   def test_contents_validation
      @message.must_be_valid_with contents: 'Awesome Message Here !'
      @message.wont_be_valid_with contents: nil
      @message.wont_be_valid_with contents: ''
   end
end

class MessageMarkdownTest < MiniTest::Spec

   def setup
      DatabaseCleaner.start
      @message = Message.new
      @message.account = Account.first
   end

   def teardown
      DatabaseCleaner.clean
   end

   def test_contents_is_automatically_parsed_when_saved
      @message.contents = <<-MSG
**Awesome Message Here !**
      MSG
      @message.parsed_contents.wont_be :present?
      @message.save
      @message.parsed_contents.must_be :present?
      @message.parsed_contents.must_match /<strong>Awesome Message Here !<\/strong>/ #/

      @message.contents = <<-MSG
**Edited Message Here !**
      MSG
      @message.save
      @message.parsed_contents.must_match /<strong>Edited Message Here !<\/strong>/
   end
end
