require_relative 'helpers'

class NewsTest < MiniTest::Spec

   def setup
      @news = News.new
   end

   def test_title_validation
      @news.must_be_valid_with title: 'Title !'
      @news.wont_be_valid_with title: nil
      @news.wont_be_valid_with title: ''
   end

   def test_summary_validation
      @news.must_be_valid_with summary: 'Summary !'
      @news.wont_be_valid_with summary: nil
      @news.wont_be_valid_with summary: ''
   end

   def test_contents_validation
      @news.must_be_valid_with contents: 'Contents !'
      @news.wont_be_valid_with contents: nil
      @news.wont_be_valid_with contents: ''
   end

   def test_banner_validation
      @news.must_be_valid_with banner: 'http://google.com'
      @news.must_be_valid_with banner: nil
      @news.wont_be_valid_with banner: ''
      @news.wont_be_valid_with banner: 'Notanurl'
      @news.wont_be_valid_with banner: 'git://notavaliduri'
   end
end
