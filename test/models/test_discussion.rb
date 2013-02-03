require_relative 'helpers'

class DiscussionTest < MiniTest::Spec

   def setup
      @discussion = Discussion.new
   end

   def test_name_validation
      @discussion.must_be_valid_with name: 'Nom de discussion'
      @discussion.wont_be_valid_with name: nil
      @discussion.wont_be_valid_with name: ''
   end

   def test_messages_validations
      @discussion.must_be_valid_with messages: [Message.new]
      @discussion.wont_be_valid_with messages: []
   end
end

class DiscussionDatabaseTest < DatabaseTest::Spec

   def setup
      super
      @discussion = FactoryGirl.build :discussion
   end

   def test_messages_persistence
      @discussion.wont_be :persisted?
      @discussion.messages.each { |msg| msg.wont_be :persisted? }

      @discussion.save
      @discussion.must_be :persisted?
      @discussion.messages.each { |msg| msg.must_be :persisted? }

      @discussion.destroy
      @discussion.wont_be :persisted?
      @discussion.messages.each { |msg| msg.wont_be :persisted? }
   end
end
