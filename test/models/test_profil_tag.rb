require_relative 'helpers'

class ProfilTagTest < MiniTest::Spec

   def setup
      @tag = ProfilTag.new
   end

   def test_contents_validation
      @tag.must_be_valid_with contents: 'Hi'
      @tag.must_be_valid_with contents: 'Hi, this is a longer tag.'
      @tag.must_be_valid_with contents: '0123456789' * 12
      @tag.wont_be_valid_with contents: nil
      @tag.wont_be_valid_with contents: ''
      @tag.wont_be_valid_with contents: '!'
      @tag.wont_be_valid_with contents: '0123456789' * 12 + '!'
   end
end
