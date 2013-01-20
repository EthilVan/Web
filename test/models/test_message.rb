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
