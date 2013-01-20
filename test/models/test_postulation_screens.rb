require_relative 'helpers'

class PostulationScreenTest < MiniTest::Spec

   def setup
      @screen = PostulationScreen.new
   end

   def test_url_validation
      @screen.must_be_valid_with url: 'http://example.com'
      @screen.wont_be_valid_with url: nil
      @screen.wont_be_valid_with url: ''
   end

   def test_description_validation
      @screen.must_be_valid_with description: <<-TEXT
Voila ma super description de la mort qui tue, trop de la balle !!!!111
      TEXT
      @screen.wont_be_valid_with description: nil
      @screen.wont_be_valid_with description: ''
      @screen.wont_be_valid_with description: '0123456789'
   end
end
