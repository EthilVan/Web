require_relative 'helpers'

class DiscussionGroupTest < MiniTest::Spec

   def setup
      @group = GeneralDiscussionGroup.new
   end

   def test_name_validation
      @group.must_be_valid_with name: 'Nom'
      @group.wont_be_valid_with name: nil
      @group.wont_be_valid_with name: ''
   end

   def test_url_validation
      @group.must_be_valid_with url: 'url_du_groupe1991'
      @group.wont_be_valid_with url: nil
      @group.wont_be_valid_with url: ''
      @group.wont_be_valid_with url: 'abcDe'
      @group.wont_be_valid_with url: '_abcde'
      @group.wont_be_valid_with url: '0abcde'
      @group.wont_be_valid_with url: 'a/a'
      @group.wont_be_valid_with url: 'a%'
   end
end

class DiscussionDatabaseTest < DatabaseTest::Spec

   def setup
      super
      @group = FactoryGirl.build :discussion_group
   end

   def test_discussions_persistence
      @group.wont_be :persisted?
      @group.discussions.each { |discussion| discussion.wont_be :persisted? }

      @group.save
      @group.must_be :persisted?
      @group.discussions.each { |discussion| discussion.must_be :persisted? }

      @group.destroy
      @group.wont_be :persisted?
      @group.discussions.each { |discussion| discussion.wont_be :persisted? }
   end
end
