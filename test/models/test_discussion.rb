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
end

class DiscussionDatabaseTest < DatabaseTest::Spec

end
