require_relative 'helpers'

class AuthTest < DatabaseTest::Spec

   def test_login_is_accessible
      get '/login'
      response.must_be :ok?
   end

   def test_member_dons_is_not_accessible_when_not_logged
      get '/membre/dons'
      response.wont_be :ok?
   end

   def test_member_is_accessible_when_logged
      login 'user'
      get '/membre/dons'
      response.must_be :ok?
   end

   def test_news_index_does_not_display_private_news_when_not_logged_in
      get '/news'
      response.body.must_include parsed_summary :public
      response.body.must_include 'Private News'
      response.body.wont_include parsed_summary :private
   end

   def test_news_index_do_display_private_news_when_logged_in
      login 'user'
      get '/news'
      response.body.must_include parsed_summary :public
      response.body.must_include parsed_summary :private
   end

private

   def parsed_summary(private)
      News.where(private: private == :private).first.parsed_summary
   end
end
