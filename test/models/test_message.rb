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

   def test_editable_by?
      user =      Account.where(role_id: 'default'  ).first
      redacteur = Account.where(role_id: 'redacteur').first
      modo =      Account.where(role_id: 'modo'     ).first
      @message.account = user

      @message.must_be :editable_by?, user
      @message.wont_be :editable_by?, redacteur
      @message.must_be :editable_by?, modo
   end
end

class MessageDatabaseTest < DatabaseTest::Spec

   def setup
      super
      @message = Message.new
      @message.account = Account.first
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
